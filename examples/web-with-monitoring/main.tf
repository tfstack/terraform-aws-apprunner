# Random string for unique naming
resource "random_string" "suffix" {
  length  = 4
  special = false
  upper   = false
}

# Local values for naming and tags
locals {
  base_name = "web-app-monitored-${random_string.suffix.result}"
  tags = {
    Name        = local.base_name
    Environment = "dev"
    Project     = "app-runner-example"
    ManagedBy   = "terraform"
  }
}

# App Runner Module with Monitoring
module "app_runner" {
  source = "../../"

  # Service Configuration
  service_name = local.base_name
  source_type  = "container"

  # Container Configuration
  container_config = {
    image_identifier           = "public.ecr.aws/aws-containers/hello-app-runner:latest"
    image_repository_type      = "ECR_PUBLIC"
    create_image_configuration = false
    port                       = "8000"
  }

  # Auto Deployments
  auto_deployments_enabled = false # ECR_PUBLIC doesn't support auto deployments

  # Instance Configuration
  cpu    = "256"
  memory = "512"

  # Health Check Configuration
  healthy_threshold     = 1
  interval              = 10
  health_check_path     = "/"
  health_check_protocol = "HTTP"
  timeout               = 5
  unhealthy_threshold   = 5

  # IAM Configuration
  create_instance_role = true

  # Monitoring Configuration
  create_monitoring = true
  create_sns_topic  = true
  alarm_email_addresses = [
    "admin@example.com" # Replace with your email
  ]

  # Web app specific alarm thresholds
  alarm_thresholds = {
    response_time = {
      enabled            = true
      threshold          = 2000 # 2 seconds
      period             = 300
      evaluation_periods = 2
    }
    error_rate = {
      enabled            = true
      threshold          = 10 # 10%
      period             = 300
      evaluation_periods = 2
    }
    cpu_utilization = {
      enabled            = true
      threshold          = 70 # 70%
      period             = 300
      evaluation_periods = 2
    }
    memory_utilization = {
      enabled            = true
      threshold          = 80 # 80%
      period             = 300
      evaluation_periods = 2
    }
    active_instances = {
      enabled            = true
      threshold          = 1 # Minimum 1 instance
      period             = 300
      evaluation_periods = 2
      operator           = "LessThanThreshold"
    }
  }

  # Monitoring configuration
  monitoring_config = {
    create_dashboard = true
    dashboard_widgets = {
      show_metrics = true
      show_logs    = true
      show_traces  = true
    }
    application_type = "web"
  }

  # X-Ray Tracing
  enable_xray_tracing = true

  # Tags
  tags = local.tags
}

# Outputs
output "web_app_url" {
  description = "URL of the App Runner service"
  value       = module.app_runner.service_url
}

output "web_app_arn" {
  description = "ARN of the App Runner service"
  value       = module.app_runner.service_arn
}

output "monitoring_dashboard_url" {
  description = "URL of the CloudWatch dashboard"
  value       = module.app_runner.cloudwatch_dashboard_url
}

output "sns_topic_arn" {
  description = "ARN of the SNS topic for notifications"
  value       = module.app_runner.sns_topic_arn
}

output "alarm_arns" {
  description = "ARNs of the CloudWatch alarms"
  value       = module.app_runner.alarm_arns
}
