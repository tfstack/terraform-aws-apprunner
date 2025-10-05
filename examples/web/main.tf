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
  base_name = "web-app-${random_string.suffix.result}"
  tags = {
    Name        = local.base_name
    Environment = "dev"
    Project     = "app-runner-example"
    ManagedBy   = "terraform"
  }
}

# App Runner Module
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
