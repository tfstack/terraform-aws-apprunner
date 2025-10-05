# Service Information
output "service_id" {
  description = "The App Runner service ID"
  value       = aws_apprunner_service.this.id
}

output "service_arn" {
  description = "The App Runner service ARN"
  value       = aws_apprunner_service.this.arn
}

output "service_name" {
  description = "The App Runner service name"
  value       = aws_apprunner_service.this.service_name
}

output "service_url" {
  description = "The App Runner service URL"
  value       = aws_apprunner_service.this.service_url
}

output "status" {
  description = "The current state of the App Runner service"
  value       = aws_apprunner_service.this.status
}

# IAM Role Information
output "app_runner_role_arn" {
  description = "The ARN of the App Runner IAM role"
  value       = var.create_iam_role ? aws_iam_role.app_runner[0].arn : null
}

output "app_runner_role_name" {
  description = "The name of the App Runner IAM role"
  value       = var.create_iam_role ? aws_iam_role.app_runner[0].name : null
}

output "instance_role_arn" {
  description = "The ARN of the App Runner instance IAM role"
  value       = var.create_instance_role ? aws_iam_role.app_runner_instance[0].arn : var.instance_role_arn
}

output "instance_role_name" {
  description = "The name of the App Runner instance IAM role"
  value       = var.create_instance_role ? aws_iam_role.app_runner_instance[0].name : null
}

# VPC Connector Information
output "vpc_connector_arn" {
  description = "The ARN of the VPC connector"
  value       = var.create_vpc_connector ? aws_apprunner_vpc_connector.this[0].arn : var.vpc_connector_arn
}

output "vpc_connector_id" {
  description = "The ID of the VPC connector"
  value       = var.create_vpc_connector ? aws_apprunner_vpc_connector.this[0].id : null
}

# Auto Scaling Configuration
output "auto_scaling_configuration_arn" {
  description = "The ARN of the auto scaling configuration"
  value       = var.create_auto_scaling_configuration ? aws_apprunner_auto_scaling_configuration_version.this[0].arn : null
}

output "auto_scaling_configuration_name" {
  description = "The name of the auto scaling configuration"
  value       = var.create_auto_scaling_configuration ? aws_apprunner_auto_scaling_configuration_version.this[0].auto_scaling_configuration_name : null
}

# Custom Domain Information
output "custom_domain_name" {
  description = "The custom domain name"
  value       = var.custom_domain != null ? aws_apprunner_custom_domain_association.this[0].domain_name : null
}

output "custom_domain_certificate_validation_records" {
  description = "The certificate validation records for the custom domain"
  value       = var.custom_domain != null ? aws_apprunner_custom_domain_association.this[0].certificate_validation_records : null
}

output "custom_domain_dns_target" {
  description = "The DNS target for the custom domain"
  value       = var.custom_domain != null ? aws_apprunner_custom_domain_association.this[0].dns_target : null
}

output "custom_domain_status" {
  description = "The status of the custom domain association"
  value       = var.custom_domain != null ? aws_apprunner_custom_domain_association.this[0].status : null
}

# CloudWatch Logs IAM Policy Information
output "cloudwatch_logs_iam_policy_id" {
  description = "The ID of the IAM policy for CloudWatch logs"
  value       = var.create_instance_role ? aws_iam_role_policy.app_runner_instance_cloudwatch_logs[0].id : null
}

output "cloudwatch_logs_iam_policy_name" {
  description = "The name of the IAM policy for CloudWatch logs"
  value       = var.create_instance_role ? aws_iam_role_policy.app_runner_instance_cloudwatch_logs[0].name : null
}

# Connection Information
output "connection_arn" {
  description = "The ARN of the App Runner connection"
  value       = var.source_type == "source_code" && var.source_code_config != null && try(var.source_code_config.connection_provider, null) != null ? aws_apprunner_connection.this[0].arn : null
}

output "connection_name" {
  description = "The name of the App Runner connection"
  value       = var.source_type == "source_code" && var.source_code_config != null && try(var.source_code_config.connection_provider, null) != null ? aws_apprunner_connection.this[0].connection_name : null
}

# Monitoring Information
output "sns_topic_arn" {
  description = "The ARN of the SNS topic for alarm notifications"
  value       = var.create_monitoring && var.create_sns_topic ? aws_sns_topic.alerts[0].arn : var.sns_topic_arn
}

output "cloudwatch_dashboard_url" {
  description = "The URL of the CloudWatch dashboard"
  value       = var.create_monitoring ? "https://${data.aws_region.current.region}.console.aws.amazon.com/cloudwatch/home?region=${data.aws_region.current.region}#dashboards:name=${aws_cloudwatch_dashboard.app_runner[0].dashboard_name}" : null
}

output "alarm_arns" {
  description = "The ARNs of the CloudWatch alarms"
  value = var.create_monitoring ? {
    response_time      = try(aws_cloudwatch_metric_alarm.response_time[0].arn, null)
    error_rate         = try(aws_cloudwatch_metric_alarm.error_rate[0].arn, null)
    cpu_utilization    = try(aws_cloudwatch_metric_alarm.cpu_utilization[0].arn, null)
    memory_utilization = try(aws_cloudwatch_metric_alarm.memory_utilization[0].arn, null)
    active_instances   = try(aws_cloudwatch_metric_alarm.active_instances[0].arn, null)
  } : null
}
