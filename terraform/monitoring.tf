# CloudWatch Log Group for application logs
resource "aws_cloudwatch_log_group" "sudoku_app_logs" {
  name              = "/aws/cloudfront/sudoku-app"
  retention_in_days = 30

  tags = {
    Name = "Sudoku App Logs"
  }
}

# CloudWatch Dashboard
resource "aws_cloudwatch_dashboard" "sudoku_app_dashboard" {
  dashboard_name = "SudokuAppDashboard"

  dashboard_body = jsonencode({
    widgets = [
      {
        type   = "metric"
        x      = 0
        y      = 0
        width  = 12
        height = 6

        properties = {
          metrics = [
            ["AWS/CloudFront", "Requests", "DistributionId", aws_cloudfront_distribution.sudoku_app.id],
            [".", "BytesDownloaded", ".", "."],
            [".", "4xxErrorRate", ".", "."],
            [".", "5xxErrorRate", ".", "."]
          ]
          view    = "timeSeries"
          stacked = false
          region  = var.aws_region
          title   = "CloudFront Metrics"
          period  = 300
        }
      },
      {
        type   = "metric"
        x      = 0
        y      = 6
        width  = 12
        height = 6

        properties = {
          metrics = [
            ["AWS/S3", "BucketSizeBytes", "BucketName", aws_s3_bucket.sudoku_app.bucket, "StorageType", "StandardStorage"],
            [".", "NumberOfObjects", ".", ".", ".", "AllStorageTypes"]
          ]
          view    = "timeSeries"
          stacked = false
          region  = var.aws_region
          title   = "S3 Storage Metrics"
          period  = 86400
        }
      }
    ]
  })
}

# CloudWatch Alarms
resource "aws_cloudwatch_metric_alarm" "high_error_rate" {
  alarm_name          = "sudoku-app-high-error-rate"
  comparison_operator = "GreaterThanThreshold"
  evaluation_periods  = "2"
  metric_name         = "4xxErrorRate"
  namespace           = "AWS/CloudFront"
  period              = "300"
  statistic           = "Average"
  threshold           = "5"
  alarm_description   = "This metric monitors CloudFront 4xx error rate"
  alarm_actions       = [aws_sns_topic.alerts.arn]

  dimensions = {
    DistributionId = aws_cloudfront_distribution.sudoku_app.id
  }

  tags = {
    Name = "Sudoku App High Error Rate"
  }
}

resource "aws_cloudwatch_metric_alarm" "low_request_count" {
  alarm_name          = "sudoku-app-low-traffic"
  comparison_operator = "LessThanThreshold"
  evaluation_periods  = "3"
  metric_name         = "Requests"
  namespace           = "AWS/CloudFront"
  period              = "3600"
  statistic           = "Sum"
  threshold           = "10"
  alarm_description   = "This metric monitors low traffic to the application"
  alarm_actions       = [aws_sns_topic.alerts.arn]

  dimensions = {
    DistributionId = aws_cloudfront_distribution.sudoku_app.id
  }

  tags = {
    Name = "Sudoku App Low Traffic"
  }
}

# SNS Topic for alerts
resource "aws_sns_topic" "alerts" {
  name = "sudoku-app-alerts"

  tags = {
    Name = "Sudoku App Alerts"
  }
}

# SNS Topic Subscription (email)
resource "aws_sns_topic_subscription" "email_alerts" {
  topic_arn = aws_sns_topic.alerts.arn
  protocol  = "email"
  endpoint  = var.alert_email
}

# Real User Monitoring with CloudWatch RUM
resource "aws_rum_app_monitor" "sudoku_app_rum" {
  name   = "sudoku-app-monitor"
  domain = aws_cloudfront_distribution.sudoku_app.domain_name

  app_monitor_configuration {
    allow_cookies      = true
    enable_xray        = false
    session_sample_rate = 0.1
    telemetries        = ["errors", "performance", "http"]
  }

  tags = {
    Name = "Sudoku App RUM"
  }
}

# X-Ray tracing for detailed performance monitoring
resource "aws_xray_sampling_rule" "sudoku_app_sampling" {
  rule_name      = "sudoku-app-sampling"
  priority       = 9000
  version        = 1
  reservoir_size = 1
  fixed_rate     = 0.1
  url_path       = "*"
  host           = "*"
  http_method    = "*"
  service_type   = "*"
  service_name   = "*"
  resource_arn   = "*"
}
