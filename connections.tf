# App Runner Connections
# Connection for GitHub/Bitbucket repositories
resource "aws_apprunner_connection" "this" {
  count = var.source_type == "source_code" && var.source_code_config != null && try(var.source_code_config.connection_provider, null) != null ? 1 : 0

  connection_name = var.source_code_config != null && try(var.source_code_config.connection_name, null) != null ? var.source_code_config.connection_name : "${var.service_name}-connection"
  provider_type   = var.source_code_config.connection_provider

  tags = var.tags
}
