# App Runner Extensions
# Custom domain association
resource "aws_apprunner_custom_domain_association" "this" {
  count = var.custom_domain != null ? 1 : 0

  domain_name          = var.custom_domain
  service_arn          = aws_apprunner_service.this.arn
  enable_www_subdomain = var.enable_www_subdomain
}

# VPC connector
resource "aws_apprunner_vpc_connector" "this" {
  count = var.create_vpc_connector ? 1 : 0

  vpc_connector_name = var.vpc_connector_name != null ? var.vpc_connector_name : "${var.service_name}-vpc-connector"
  subnets            = var.subnet_ids
  security_groups    = var.security_group_ids

  tags = var.tags
}

# Auto scaling configuration
resource "aws_apprunner_auto_scaling_configuration_version" "this" {
  count = var.create_auto_scaling_configuration ? 1 : 0

  auto_scaling_configuration_name = var.auto_scaling_configuration_name != null ? var.auto_scaling_configuration_name : "${var.service_name}-auto-scaling"
  max_concurrency                 = var.max_concurrency
  max_size                        = var.max_size
  min_size                        = var.min_size

  tags = var.tags
}
