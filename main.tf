# Data sources
data "aws_region" "current" {}
data "aws_caller_identity" "current" {}

# App Runner Service
# Observability configuration for X-Ray tracing
resource "aws_apprunner_observability_configuration" "this" {
  count = var.enable_xray_tracing ? 1 : 0

  observability_configuration_name = "${substr(replace(var.service_name, "-", ""), 0, 20)}-obs"
  trace_configuration {
    vendor = "AWSXRAY"
  }

  tags = var.tags
}

resource "aws_apprunner_service" "this" {
  service_name = var.service_name

  source_configuration {
    # Container deployments
    dynamic "image_repository" {
      for_each = var.source_type == "container" ? [1] : []
      content {
        image_identifier      = var.container_config.image_identifier
        image_repository_type = var.container_config.image_repository_type

        dynamic "image_configuration" {
          for_each = var.container_config.create_image_configuration ? [1] : []
          content {
            port                          = var.container_config.port
            runtime_environment_variables = var.container_config.environment_variables
            runtime_environment_secrets   = var.container_config.environment_secrets
            start_command                 = var.container_config.start_command
          }
        }
      }
    }

    # Source code deployments
    dynamic "code_repository" {
      for_each = var.source_type == "source_code" ? [1] : []
      content {
        repository_url = var.source_code_config.repository_url
        source_code_version {
          type  = var.source_code_config.source_code_version.type
          value = var.source_code_config.source_code_version.value
        }

        code_configuration {
          configuration_source = var.source_code_config.code_configuration.configuration_source

          dynamic "code_configuration_values" {
            for_each = var.source_code_config.code_configuration.configuration_source == "API" ? [1] : []
            content {
              runtime                       = var.source_code_config.code_configuration.runtime
              build_command                 = var.source_code_config.code_configuration.build_command
              start_command                 = var.source_code_config.code_configuration.start_command
              runtime_environment_variables = var.source_code_config.code_configuration.runtime_environment_variables
              runtime_environment_secrets   = var.source_code_config.code_configuration.runtime_environment_secrets
            }
          }
        }

      }
    }

    auto_deployments_enabled = var.auto_deployments_enabled

    # Authentication configuration for source code deployments
    dynamic "authentication_configuration" {
      for_each = var.source_type == "source_code" && var.source_code_config != null && try(var.source_code_config.connection_provider, null) != null ? [1] : []
      content {
        connection_arn = aws_apprunner_connection.this[0].arn
      }
    }
  }

  instance_configuration {
    cpu               = var.cpu
    memory            = var.memory
    instance_role_arn = var.create_instance_role ? aws_iam_role.app_runner_instance[0].arn : var.instance_role_arn
  }

  health_check_configuration {
    healthy_threshold   = var.healthy_threshold
    interval            = var.interval
    path                = var.health_check_path
    protocol            = var.health_check_protocol
    timeout             = var.timeout
    unhealthy_threshold = var.unhealthy_threshold
  }

  network_configuration {
    egress_configuration {
      egress_type       = var.egress_type
      vpc_connector_arn = var.vpc_connector_arn
    }
  }

  # Observability configuration for X-Ray tracing
  dynamic "observability_configuration" {
    for_each = var.enable_xray_tracing ? [1] : []
    content {
      observability_enabled           = true
      observability_configuration_arn = aws_apprunner_observability_configuration.this[0].arn
    }
  }

  tags = var.tags

  depends_on = [
    aws_iam_role_policy.app_runner_instance_ecr_policy,
    aws_iam_role_policy.app_runner_instance_cloudwatch_logs,
    aws_iam_role_policy.app_runner_instance_custom
  ]
}
