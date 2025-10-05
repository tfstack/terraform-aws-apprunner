# CloudWatch Monitoring and Alarms
# SNS Topic for alarm notifications
resource "aws_sns_topic" "alerts" {
  count = var.create_monitoring && var.create_sns_topic && var.sns_topic_arn == null ? 1 : 0
  name  = var.sns_topic_name != null ? var.sns_topic_name : "${var.service_name}-alerts"

  tags = var.tags
}

# SNS Topic Subscriptions
resource "aws_sns_topic_subscription" "email_notifications" {
  count     = var.create_monitoring && var.create_sns_topic && length(var.alarm_email_addresses) > 0 ? length(var.alarm_email_addresses) : 0
  topic_arn = aws_sns_topic.alerts[0].arn
  protocol  = "email"
  endpoint  = var.alarm_email_addresses[count.index]
}

# CloudWatch Alarms
# Response Time Alarm
resource "aws_cloudwatch_metric_alarm" "response_time" {
  count = var.create_monitoring && try(var.alarm_thresholds.response_time.enabled, true) ? 1 : 0

  alarm_name          = "${var.service_name}-response-time"
  comparison_operator = "GreaterThanThreshold"
  evaluation_periods  = try(var.alarm_thresholds.response_time.evaluation_periods, 2)
  metric_name         = "RequestLatency"
  namespace           = "AWS/AppRunner"
  period              = try(var.alarm_thresholds.response_time.period, 300)
  statistic           = "Average"
  threshold           = try(var.alarm_thresholds.response_time.threshold, 1000)
  alarm_description   = "This metric monitors App Runner response time"
  alarm_actions       = var.sns_topic_arn != null ? [var.sns_topic_arn] : (var.create_sns_topic ? [aws_sns_topic.alerts[0].arn] : [])

  dimensions = {
    ServiceName = aws_apprunner_service.this.service_name
  }

  tags = var.tags
}

# Error Rate Alarm
resource "aws_cloudwatch_metric_alarm" "error_rate" {
  count = var.create_monitoring && try(var.alarm_thresholds.error_rate.enabled, true) ? 1 : 0

  alarm_name          = "${var.service_name}-error-rate"
  comparison_operator = "GreaterThanThreshold"
  evaluation_periods  = try(var.alarm_thresholds.error_rate.evaluation_periods, 2)
  metric_name         = "HTTP5xxErrorRate"
  namespace           = "AWS/AppRunner"
  period              = try(var.alarm_thresholds.error_rate.period, 300)
  statistic           = "Average"
  threshold           = try(var.alarm_thresholds.error_rate.threshold, 5)
  alarm_description   = "This metric monitors App Runner 5xx error rate"
  alarm_actions       = var.sns_topic_arn != null ? [var.sns_topic_arn] : (var.create_sns_topic ? [aws_sns_topic.alerts[0].arn] : [])

  dimensions = {
    ServiceName = aws_apprunner_service.this.service_name
  }

  tags = var.tags
}

# CPU Utilization Alarm
resource "aws_cloudwatch_metric_alarm" "cpu_utilization" {
  count = var.create_monitoring && try(var.alarm_thresholds.cpu_utilization.enabled, true) ? 1 : 0

  alarm_name          = "${var.service_name}-cpu-utilization"
  comparison_operator = "GreaterThanThreshold"
  evaluation_periods  = try(var.alarm_thresholds.cpu_utilization.evaluation_periods, 2)
  metric_name         = "CPUUtilization"
  namespace           = "AWS/AppRunner"
  period              = try(var.alarm_thresholds.cpu_utilization.period, 300)
  statistic           = "Average"
  threshold           = try(var.alarm_thresholds.cpu_utilization.threshold, 80)
  alarm_description   = "This metric monitors App Runner CPU utilization"
  alarm_actions       = var.sns_topic_arn != null ? [var.sns_topic_arn] : (var.create_sns_topic ? [aws_sns_topic.alerts[0].arn] : [])

  dimensions = {
    ServiceName = aws_apprunner_service.this.service_name
  }

  tags = var.tags
}

# Memory Utilization Alarm
resource "aws_cloudwatch_metric_alarm" "memory_utilization" {
  count = var.create_monitoring && try(var.alarm_thresholds.memory_utilization.enabled, true) ? 1 : 0

  alarm_name          = "${var.service_name}-memory-utilization"
  comparison_operator = "GreaterThanThreshold"
  evaluation_periods  = try(var.alarm_thresholds.memory_utilization.evaluation_periods, 2)
  metric_name         = "MemoryUtilization"
  namespace           = "AWS/AppRunner"
  period              = try(var.alarm_thresholds.memory_utilization.period, 300)
  statistic           = "Average"
  threshold           = try(var.alarm_thresholds.memory_utilization.threshold, 80)
  alarm_description   = "This metric monitors App Runner memory utilization"
  alarm_actions       = var.sns_topic_arn != null ? [var.sns_topic_arn] : (var.create_sns_topic ? [aws_sns_topic.alerts[0].arn] : [])

  dimensions = {
    ServiceName = aws_apprunner_service.this.service_name
  }

  tags = var.tags
}

# Active Instances Alarm
resource "aws_cloudwatch_metric_alarm" "active_instances" {
  count = var.create_monitoring && try(var.alarm_thresholds.active_instances.enabled, true) ? 1 : 0

  alarm_name          = "${var.service_name}-active-instances"
  comparison_operator = try(var.alarm_thresholds.active_instances.operator, "LessThanThreshold")
  evaluation_periods  = try(var.alarm_thresholds.active_instances.evaluation_periods, 2)
  metric_name         = "ActiveInstances"
  namespace           = "AWS/AppRunner"
  period              = try(var.alarm_thresholds.active_instances.period, 300)
  statistic           = "Average"
  threshold           = try(var.alarm_thresholds.active_instances.threshold, 1)
  alarm_description   = "This metric monitors App Runner active instances"
  alarm_actions       = var.sns_topic_arn != null ? [var.sns_topic_arn] : (var.create_sns_topic ? [aws_sns_topic.alerts[0].arn] : [])

  dimensions = {
    ServiceName = aws_apprunner_service.this.service_name
  }

  tags = var.tags
}

# Custom Metrics Alarms
resource "aws_cloudwatch_metric_alarm" "custom" {
  for_each = {
    for metric in var.monitoring_config.custom_metrics : metric.metric_name => metric
    if var.create_monitoring && try(metric.enabled, true)
  }

  alarm_name          = "${var.service_name}-${each.value.metric_name}"
  comparison_operator = each.value.operator
  evaluation_periods  = 2
  metric_name         = each.value.metric_name
  namespace           = each.value.namespace
  period              = 300
  statistic           = each.value.statistic
  threshold           = each.value.threshold
  alarm_description   = "Custom metric alarm for ${each.value.metric_name}"
  alarm_actions       = var.sns_topic_arn != null ? [var.sns_topic_arn] : (var.create_sns_topic ? [aws_sns_topic.alerts[0].arn] : [])

  dimensions = {
    ServiceName = aws_apprunner_service.this.service_name
  }

  tags = var.tags
}

# CloudWatch Dashboard
resource "aws_cloudwatch_dashboard" "app_runner" {
  count = var.create_monitoring && try(var.monitoring_config.create_dashboard, true) ? 1 : 0

  dashboard_name = "${var.service_name}-dashboard"

  dashboard_body = jsonencode({
    widgets = concat(
      # Standard App Runner metrics
      try(var.monitoring_config.dashboard_widgets.show_metrics, true) ? [
        {
          type   = "metric"
          x      = 0
          y      = 0
          width  = 12
          height = 6

          properties = {
            metrics = concat(
              # Response time and error rate (for web/API apps)
              try(var.monitoring_config.application_type, "web") == "web" || try(var.monitoring_config.application_type, "web") == "api" ? [
                ["AWS/AppRunner", "RequestLatency", "ServiceName", aws_apprunner_service.this.service_id],
                [".", "HTTP5xxErrorRate", ".", "."]
              ] : [],
              # Resource utilization (for all apps)
              [
                ["AWS/AppRunner", "CPUUtilization", "ServiceName", aws_apprunner_service.this.service_id],
                [".", "MemoryUtilization", ".", "."],
                [".", "ActiveInstances", ".", "."]
              ]
            )
            view    = "timeSeries"
            stacked = false
            region  = data.aws_region.current.region
            title   = "App Runner Service Metrics"
            period  = 300
          }
        }
      ] : [],
      # Logs widget
      try(var.monitoring_config.dashboard_widgets.show_logs, true) ? [
        {
          type   = "log"
          x      = 0
          y      = 6
          width  = 24
          height = 6

          properties = {
            query  = "SOURCE '/aws/apprunner/${aws_apprunner_service.this.service_name}/${aws_apprunner_service.this.service_id}/service' | fields @timestamp, @message | sort @timestamp desc | limit 100"
            region = data.aws_region.current.region
            title  = "App Runner Service Logs"
            view   = "table"
          }
        }
      ] : [],
    )
  })
}
