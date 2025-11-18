terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }
  }
}

provider "aws" {
  region = var.aws_region
}

provider "aws" {
  alias  = "backup_region"
  region = var.backup_region
}

# CloudFront security headers function
resource "aws_cloudfront_function" "security_headers" {
  name    = "security-headers"
  runtime = "cloudfront-js-2.0"
  code    = file("${path.module}/security-headers.js")
}

# S3 bucket for hosting the web application
resource "aws_s3_bucket" "sudoku_app" {
  bucket = var.bucket_name
}

# Enable S3 versioning
resource "aws_s3_bucket_versioning" "sudoku_app" {
  bucket = aws_s3_bucket.sudoku_app.id
  versioning_configuration {
    status = "Enabled"
  }
}

# Enable S3 server-side encryption
resource "aws_s3_bucket_server_side_encryption_configuration" "sudoku_app" {
  bucket = aws_s3_bucket.sudoku_app.id

  rule {
    apply_server_side_encryption_by_default {
      sse_algorithm = "AES256"
    }
  }
}

# Backup S3 bucket in different region
resource "aws_s3_bucket" "sudoku_app_backup" {
  bucket   = "${var.bucket_name}-backup"
  provider = aws.backup_region
}

resource "aws_s3_bucket_versioning" "sudoku_app_backup" {
  bucket   = aws_s3_bucket.sudoku_app_backup.id
  provider = aws.backup_region
  versioning_configuration {
    status = "Enabled"
  }
}

# IAM role for S3 replication
resource "aws_iam_role" "replication" {
  name = "s3-replication-role"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = "sts:AssumeRole"
        Effect = "Allow"
        Principal = {
          Service = "s3.amazonaws.com"
        }
      }
    ]
  })
}

resource "aws_iam_policy" "replication" {
  name = "s3-replication-policy"

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect = "Allow"
        Action = [
          "s3:GetObjectVersionForReplication",
          "s3:GetObjectVersionAcl"
        ]
        Resource = "${aws_s3_bucket.sudoku_app.arn}/*"
      },
      {
        Effect = "Allow"
        Action = [
          "s3:ListBucket"
        ]
        Resource = aws_s3_bucket.sudoku_app.arn
      },
      {
        Effect = "Allow"
        Action = [
          "s3:ReplicateObject",
          "s3:ReplicateDelete"
        ]
        Resource = "${aws_s3_bucket.sudoku_app_backup.arn}/*"
      }
    ]
  })
}

resource "aws_iam_role_policy_attachment" "replication" {
  role       = aws_iam_role.replication.name
  policy_arn = aws_iam_policy.replication.arn
}

# S3 cross-region replication
resource "aws_s3_bucket_replication_configuration" "sudoku_app" {
  role   = aws_iam_role.replication.arn
  bucket = aws_s3_bucket.sudoku_app.id

  rule {
    id     = "replicate-to-backup"
    status = "Enabled"

    destination {
      bucket        = aws_s3_bucket.sudoku_app_backup.arn
      storage_class = "STANDARD_IA"
    }
  }

  depends_on = [aws_s3_bucket_versioning.sudoku_app]
}

# S3 bucket for CloudFront logs
resource "aws_s3_bucket" "cloudfront_logs" {
  bucket = "${var.bucket_name}-cloudfront-logs"
}

resource "aws_s3_bucket_public_access_block" "cloudfront_logs" {
  bucket = aws_s3_bucket.cloudfront_logs.id

  block_public_acls       = true
  block_public_policy     = true
  ignore_public_acls      = true
  restrict_public_buckets = true
}

resource "aws_s3_bucket_public_access_block" "sudoku_app" {
  bucket = aws_s3_bucket.sudoku_app.id

  block_public_acls       = true
  block_public_policy     = true
  ignore_public_acls      = true
  restrict_public_buckets = true
}

# CloudFront Origin Access Control
resource "aws_cloudfront_origin_access_control" "sudoku_app" {
  name                              = "sudoku-app-oac"
  description                       = "OAC for Sudoku app S3 bucket"
  origin_access_control_origin_type = "s3"
  signing_behavior                  = "always"
  signing_protocol                  = "sigv4"
}

# AWS WAF for CloudFront
resource "aws_wafv2_web_acl" "sudoku_app_waf" {
  name  = "sudoku-app-waf"
  scope = "CLOUDFRONT"

  default_action {
    allow {}
  }

  rule {
    name     = "AWSManagedRulesCommonRuleSet"
    priority = 1

    override_action {
      none {}
    }

    statement {
      managed_rule_group_statement {
        name        = "AWSManagedRulesCommonRuleSet"
        vendor_name = "AWS"
      }
    }

    visibility_config {
      cloudwatch_metrics_enabled = true
      metric_name                = "CommonRuleSetMetric"
      sampled_requests_enabled   = true
    }
  }

  rule {
    name     = "AWSManagedRulesKnownBadInputsRuleSet"
    priority = 2

    override_action {
      none {}
    }

    statement {
      managed_rule_group_statement {
        name        = "AWSManagedRulesKnownBadInputsRuleSet"
        vendor_name = "AWS"
      }
    }

    visibility_config {
      cloudwatch_metrics_enabled = true
      metric_name                = "KnownBadInputsRuleSetMetric"
      sampled_requests_enabled   = true
    }
  }

  tags = {
    Name = "Sudoku App WAF"
  }
}

# CloudFront distribution
resource "aws_cloudfront_distribution" "sudoku_app" {
  origin {
    domain_name              = aws_s3_bucket.sudoku_app.bucket_regional_domain_name
    origin_access_control_id = aws_cloudfront_origin_access_control.sudoku_app.id
    origin_id                = "S3-${aws_s3_bucket.sudoku_app.bucket}"
  }

  enabled             = true
  is_ipv6_enabled     = true
  default_root_object = "sudoku.html"
  web_acl_id          = aws_wafv2_web_acl.sudoku_app_waf.arn

  # Enable logging
  logging_config {
    include_cookies = false
    bucket          = aws_s3_bucket.cloudfront_logs.bucket_domain_name
    prefix          = "cloudfront-logs/"
  }

  default_cache_behavior {
    allowed_methods        = ["DELETE", "GET", "HEAD", "OPTIONS", "PATCH", "POST", "PUT"]
    cached_methods         = ["GET", "HEAD"]
    target_origin_id       = "S3-${aws_s3_bucket.sudoku_app.bucket}"
    compress               = true
    viewer_protocol_policy = "redirect-to-https"

    forwarded_values {
      query_string = false
      cookies {
        forward = "none"
      }
    }

    function_association {
      event_type   = "viewer-response"
      function_arn = aws_cloudfront_function.security_headers.arn
    }

    min_ttl     = 0
    default_ttl = 3600
    max_ttl     = 86400
  }

  # Cache behavior for CSS files
  ordered_cache_behavior {
    path_pattern     = "*.css"
    target_origin_id = "S3-${aws_s3_bucket.sudoku_app.bucket}"
    
    cache_policy_id = "4135ea2d-6df8-44a3-9df3-4b5a84be39ad" # CachingOptimized
    
    viewer_protocol_policy = "redirect-to-https"
    compress              = true
  }

  # Cache behavior for JS files
  ordered_cache_behavior {
    path_pattern     = "*.js"
    target_origin_id = "S3-${aws_s3_bucket.sudoku_app.bucket}"
    
    cache_policy_id = "4135ea2d-6df8-44a3-9df3-4b5a84be39ad" # CachingOptimized
    
    viewer_protocol_policy = "redirect-to-https"
    compress              = true
  }

  restrictions {
    geo_restriction {
      restriction_type = "none"
    }
  }

  viewer_certificate {
    cloudfront_default_certificate = true
  }

  # Custom error pages
  custom_error_response {
    error_code         = 404
    response_code      = 404
    response_page_path = "/404.html"
  }

  custom_error_response {
    error_code         = 403
    response_code      = 403
    response_page_path = "/403.html"
  }

  tags = {
    Name = "Sudoku App Distribution"
  }
}

# S3 bucket policy to allow CloudFront access
resource "aws_s3_bucket_policy" "sudoku_app" {
  bucket = aws_s3_bucket.sudoku_app.id

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Sid    = "AllowCloudFrontServicePrincipal"
        Effect = "Allow"
        Principal = {
          Service = "cloudfront.amazonaws.com"
        }
        Action   = "s3:GetObject"
        Resource = "${aws_s3_bucket.sudoku_app.arn}/*"
        Condition = {
          StringEquals = {
            "AWS:SourceArn" = aws_cloudfront_distribution.sudoku_app.arn
          }
        }
      }
    ]
  })
}

# Upload the Sudoku HTML file
resource "aws_s3_object" "sudoku_html" {
  bucket       = aws_s3_bucket.sudoku_app.id
  key          = "sudoku.html"
  source       = "../sudoku.html"
  content_type = "text/html"
  etag         = filemd5("../sudoku.html")
}

# Upload the architecture diagram
resource "aws_s3_object" "architecture_diagram" {
  bucket       = aws_s3_bucket.sudoku_app.id
  key          = "sudoku-architecture.drawio"
  source       = "../sudoku-architecture.drawio"
  content_type = "application/xml"
  etag         = filemd5("../sudoku-architecture.drawio")
}

# Upload the README file
resource "aws_s3_object" "readme" {
  bucket       = aws_s3_bucket.sudoku_app.id
  key          = "README.md"
  source       = "../README.md"
  content_type = "text/markdown"
  etag         = filemd5("../README.md")
}

# Upload error pages
resource "aws_s3_object" "error_404" {
  bucket       = aws_s3_bucket.sudoku_app.id
  key          = "404.html"
  source       = "../404.html"
  content_type = "text/html"
  etag         = filemd5("../404.html")
}

resource "aws_s3_object" "error_403" {
  bucket       = aws_s3_bucket.sudoku_app.id
  key          = "403.html"
  source       = "../403.html"
  content_type = "text/html"
  etag         = filemd5("../403.html")
}
