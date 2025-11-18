output "s3_bucket_name" {
  description = "Name of the S3 bucket"
  value       = aws_s3_bucket.sudoku_app.bucket
}

output "s3_backup_bucket_name" {
  description = "Name of the backup S3 bucket"
  value       = aws_s3_bucket.sudoku_app_backup.bucket
}

output "cloudfront_distribution_id" {
  description = "CloudFront distribution ID"
  value       = aws_cloudfront_distribution.sudoku_app.id
}

output "cloudfront_domain_name" {
  description = "CloudFront distribution domain name"
  value       = aws_cloudfront_distribution.sudoku_app.domain_name
}

output "cloudfront_distribution_domain_name" {
  description = "CloudFront distribution domain name (for CI/CD)"
  value       = aws_cloudfront_distribution.sudoku_app.domain_name
}

output "website_url" {
  description = "URL to access the Sudoku web application"
  value       = "https://${aws_cloudfront_distribution.sudoku_app.domain_name}"
}

output "architecture_diagram_url" {
  description = "URL to access the architecture diagram"
  value       = "https://${aws_cloudfront_distribution.sudoku_app.domain_name}/sudoku-architecture.drawio"
}

output "waf_web_acl_id" {
  description = "WAF Web ACL ID"
  value       = aws_wafv2_web_acl.sudoku_app_waf.id
}

output "cloudwatch_dashboard_url" {
  description = "URL to CloudWatch dashboard"
  value       = "https://${var.aws_region}.console.aws.amazon.com/cloudwatch/home?region=${var.aws_region}#dashboards:name=${aws_cloudwatch_dashboard.sudoku_app_dashboard.dashboard_name}"
}

output "rum_monitor_id" {
  description = "CloudWatch RUM App Monitor ID"
  value       = aws_rum_app_monitor.sudoku_app_rum.id
}

output "sns_topic_arn" {
  description = "SNS Topic ARN for alerts"
  value       = aws_sns_topic.alerts.arn
}
