terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = ">= 6.0"
    }
  }
}

provider "aws" {
  region = "ap-southeast-2"
}

# Random string for unique naming
resource "random_string" "suffix" {
  length  = 4
  special = false
  upper   = false
}

# Local values for naming and tags
locals {
  base_name = "api-app-monitored-${random_string.suffix.result}"
  tags = {
    Name        = local.base_name
    Environment = "dev"
    Project     = "app-runner-example"
    ManagedBy   = "terraform"
  }
}

# App Runner Module with API-focused Monitoring
module "app_runner" {
  source = "../../"

  # Service Configuration
  service_name = local.base_name
  source_type  = "container"

  # Container Configuration
  container_config = {
    image_identifier           = "public.ecr.aws/aws-containers/hello-app-runner:latest"
    image_repository_type      = "ECR_PUBLIC"
    create_image_configuration = true
    port                       = "8080"
  }

  # Auto Deployments
  auto_deployments_enabled = false

  # Instance Configuration
  cpu    = "512"
  memory = "1024"

  # Health Check Configuration
  healthy_threshold     = 1
  interval              = 10
  health_check_path     = "/"
  health_check_protocol = "HTTP"
  timeout               = 5
  unhealthy_threshold   = 5

  # IAM Configuration
  create_instance_role = true

  # Monitoring Configuration - API focused
  create_monitoring = true
  create_sns_topic  = true
  alarm_email_addresses = [
    "api-team@example.com" # Replace with your email
  ]

  # API-specific alarm thresholds
  alarm_thresholds = {
    response_time = {
      enabled            = true
      threshold          = 500 # 500ms for API
      period             = 300
      evaluation_periods = 2
    }
    error_rate = {
      enabled            = true
      threshold          = 2 # 2% for API
      period             = 300
      evaluation_periods = 2
    }
    cpu_utilization = {
      enabled            = true
      threshold          = 70 # 70% for API
      period             = 300
      evaluation_periods = 2
    }
    memory_utilization = {
      enabled            = true
      threshold          = 80 # 80% for API
      period             = 300
      evaluation_periods = 2
    }
    active_instances = {
      enabled            = true
      threshold          = 2 # Minimum 2 instances for API
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
    }
    application_type = "api"
    custom_metrics = [
      {
        metric_name = "CustomAPIMetric"
        namespace   = "Custom/API"
        statistic   = "Average"
        threshold   = 100
        operator    = "GreaterThanThreshold"
        enabled     = true
      }
    ]
  }

  # X-Ray Tracing
  enable_xray_tracing = true

  # Tags
  tags = local.tags
}

# Outputs
output "api_url" {
  description = "URL of the App Runner API service"
  value       = module.app_runner.service_url
}

output "api_arn" {
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
