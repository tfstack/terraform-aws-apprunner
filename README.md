# terraform-aws-apprunner

Terraform module to provision and manage AWS App Runner services

<!-- BEGIN_TF_DOCS -->
## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_terraform"></a> [terraform](#requirement\_terraform) | >= 1.0 |
| <a name="requirement_aws"></a> [aws](#requirement\_aws) | >= 6.0.0 |

## Providers

| Name | Version |
|------|---------|
| <a name="provider_aws"></a> [aws](#provider\_aws) | 6.15.0 |

## Modules

No modules.

## Resources

| Name | Type |
|------|------|
| [aws_apprunner_auto_scaling_configuration_version.this](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/apprunner_auto_scaling_configuration_version) | resource |
| [aws_apprunner_connection.this](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/apprunner_connection) | resource |
| [aws_apprunner_custom_domain_association.this](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/apprunner_custom_domain_association) | resource |
| [aws_apprunner_observability_configuration.this](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/apprunner_observability_configuration) | resource |
| [aws_apprunner_service.this](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/apprunner_service) | resource |
| [aws_apprunner_vpc_connector.this](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/apprunner_vpc_connector) | resource |
| [aws_cloudwatch_dashboard.app_runner](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/cloudwatch_dashboard) | resource |
| [aws_cloudwatch_metric_alarm.active_instances](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/cloudwatch_metric_alarm) | resource |
| [aws_cloudwatch_metric_alarm.cpu_utilization](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/cloudwatch_metric_alarm) | resource |
| [aws_cloudwatch_metric_alarm.custom](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/cloudwatch_metric_alarm) | resource |
| [aws_cloudwatch_metric_alarm.error_rate](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/cloudwatch_metric_alarm) | resource |
| [aws_cloudwatch_metric_alarm.memory_utilization](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/cloudwatch_metric_alarm) | resource |
| [aws_cloudwatch_metric_alarm.response_time](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/cloudwatch_metric_alarm) | resource |
| [aws_iam_role.app_runner](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_role) | resource |
| [aws_iam_role.app_runner_instance](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_role) | resource |
| [aws_iam_role_policy.app_runner_instance_cloudwatch_logs](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_role_policy) | resource |
| [aws_iam_role_policy.app_runner_instance_custom](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_role_policy) | resource |
| [aws_iam_role_policy.app_runner_instance_ecr_policy](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_role_policy) | resource |
| [aws_iam_role_policy.app_runner_instance_xray](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_role_policy) | resource |
| [aws_sns_topic.alerts](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/sns_topic) | resource |
| [aws_sns_topic_subscription.email_notifications](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/sns_topic_subscription) | resource |
| [aws_caller_identity.current](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/caller_identity) | data source |
| [aws_region.current](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/region) | data source |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_alarm_email_addresses"></a> [alarm\_email\_addresses](#input\_alarm\_email\_addresses) | List of email addresses to receive alarm notifications | `list(string)` | `[]` | no |
| <a name="input_alarm_thresholds"></a> [alarm\_thresholds](#input\_alarm\_thresholds) | Thresholds for CloudWatch alarms | <pre>object({<br/>    # Response time alarm (milliseconds)<br/>    response_time = optional(object({<br/>      enabled            = optional(bool, true)<br/>      threshold          = optional(number, 1000)<br/>      period             = optional(number, 300)<br/>      evaluation_periods = optional(number, 2)<br/>    }), {})<br/><br/>    # Error rate alarm (percentage)<br/>    error_rate = optional(object({<br/>      enabled            = optional(bool, true)<br/>      threshold          = optional(number, 5)<br/>      period             = optional(number, 300)<br/>      evaluation_periods = optional(number, 2)<br/>    }), {})<br/><br/>    # CPU utilization alarm (percentage)<br/>    cpu_utilization = optional(object({<br/>      enabled            = optional(bool, true)<br/>      threshold          = optional(number, 80)<br/>      period             = optional(number, 300)<br/>      evaluation_periods = optional(number, 2)<br/>    }), {})<br/><br/>    # Memory utilization alarm (percentage)<br/>    memory_utilization = optional(object({<br/>      enabled            = optional(bool, true)<br/>      threshold          = optional(number, 80)<br/>      period             = optional(number, 300)<br/>      evaluation_periods = optional(number, 2)<br/>    }), {})<br/><br/>    # Active instances alarm (count)<br/>    active_instances = optional(object({<br/>      enabled            = optional(bool, true)<br/>      threshold          = optional(number, 1)<br/>      period             = optional(number, 300)<br/>      evaluation_periods = optional(number, 2)<br/>      operator           = optional(string, "LessThanThreshold")<br/>    }), {})<br/>  })</pre> | `{}` | no |
| <a name="input_auto_deployments_enabled"></a> [auto\_deployments\_enabled](#input\_auto\_deployments\_enabled) | Whether continuous deployment from the source repository is enabled for the App Runner service | `bool` | `true` | no |
| <a name="input_auto_scaling_configuration_name"></a> [auto\_scaling\_configuration\_name](#input\_auto\_scaling\_configuration\_name) | Name of the auto scaling configuration | `string` | `null` | no |
| <a name="input_container_config"></a> [container\_config](#input\_container\_config) | Container deployment configuration | <pre>object({<br/>    image_identifier           = string<br/>    image_repository_type      = optional(string, "ECR")<br/>    create_image_configuration = optional(bool, true)<br/>    port                       = optional(string, "8000")<br/>    environment_variables      = optional(map(string), {})<br/>    environment_secrets        = optional(map(string), {})<br/>    start_command              = optional(string, null)<br/>  })</pre> | `null` | no |
| <a name="input_cpu"></a> [cpu](#input\_cpu) | The number of CPU units reserved for each instance of your App Runner service | `string` | `"1024"` | no |
| <a name="input_create_auto_scaling_configuration"></a> [create\_auto\_scaling\_configuration](#input\_create\_auto\_scaling\_configuration) | Whether to create an auto scaling configuration | `bool` | `false` | no |
| <a name="input_create_iam_role"></a> [create\_iam\_role](#input\_create\_iam\_role) | Whether to create an IAM role for App Runner | `bool` | `false` | no |
| <a name="input_create_instance_role"></a> [create\_instance\_role](#input\_create\_instance\_role) | Whether to create an IAM role for App Runner instances | `bool` | `true` | no |
| <a name="input_create_monitoring"></a> [create\_monitoring](#input\_create\_monitoring) | Whether to create CloudWatch alarms and monitoring resources | `bool` | `false` | no |
| <a name="input_create_sns_topic"></a> [create\_sns\_topic](#input\_create\_sns\_topic) | Whether to create an SNS topic for alarm notifications | `bool` | `false` | no |
| <a name="input_create_vpc_connector"></a> [create\_vpc\_connector](#input\_create\_vpc\_connector) | Whether to create a VPC connector | `bool` | `false` | no |
| <a name="input_custom_domain"></a> [custom\_domain](#input\_custom\_domain) | Custom domain name for the App Runner service | `string` | `null` | no |
| <a name="input_egress_type"></a> [egress\_type](#input\_egress\_type) | The type of egress configuration. Valid values are DEFAULT and VPC | `string` | `"DEFAULT"` | no |
| <a name="input_enable_www_subdomain"></a> [enable\_www\_subdomain](#input\_enable\_www\_subdomain) | Whether to enable www subdomain for the custom domain | `bool` | `false` | no |
| <a name="input_enable_xray_tracing"></a> [enable\_xray\_tracing](#input\_enable\_xray\_tracing) | Whether to enable AWS X-Ray tracing for the App Runner service | `bool` | `false` | no |
| <a name="input_health_check_path"></a> [health\_check\_path](#input\_health\_check\_path) | The URL that App Runner should send a request to, using an HTTP GET request, to determine if this service is healthy | `string` | `"/"` | no |
| <a name="input_health_check_protocol"></a> [health\_check\_protocol](#input\_health\_check\_protocol) | The IP protocol that App Runner uses to perform health checks for your service | `string` | `"HTTP"` | no |
| <a name="input_healthy_threshold"></a> [healthy\_threshold](#input\_healthy\_threshold) | The number of consecutive checks that must succeed before App Runner decides that the service is healthy | `number` | `1` | no |
| <a name="input_iam_role_name"></a> [iam\_role\_name](#input\_iam\_role\_name) | Name of the IAM role for App Runner | `string` | `null` | no |
| <a name="input_instance_role_arn"></a> [instance\_role\_arn](#input\_instance\_role\_arn) | ARN of an existing IAM role for App Runner instances | `string` | `null` | no |
| <a name="input_instance_role_name"></a> [instance\_role\_name](#input\_instance\_role\_name) | Name of the IAM role for App Runner instances | `string` | `null` | no |
| <a name="input_instance_role_policy"></a> [instance\_role\_policy](#input\_instance\_role\_policy) | Custom policy document for the App Runner instance role | `string` | `null` | no |
| <a name="input_interval"></a> [interval](#input\_interval) | The time interval, in seconds, between health checks | `number` | `5` | no |
| <a name="input_max_concurrency"></a> [max\_concurrency](#input\_max\_concurrency) | The maximum number of concurrent requests that an instance processes | `number` | `100` | no |
| <a name="input_max_size"></a> [max\_size](#input\_max\_size) | The maximum number of instances that your service scales up to | `number` | `10` | no |
| <a name="input_memory"></a> [memory](#input\_memory) | The amount of memory, in MB or GB, reserved for each instance of your App Runner service | `string` | `"2048"` | no |
| <a name="input_min_size"></a> [min\_size](#input\_min\_size) | The minimum number of instances that your service scales down to | `number` | `1` | no |
| <a name="input_monitoring_config"></a> [monitoring\_config](#input\_monitoring\_config) | Configuration for monitoring features | <pre>object({<br/>    # Dashboard configuration<br/>    create_dashboard = optional(bool, true)<br/>    dashboard_widgets = optional(object({<br/>      show_metrics = optional(bool, true)<br/>      show_logs    = optional(bool, true)<br/>    }), {})<br/><br/>    # Custom metrics<br/>    custom_metrics = optional(list(object({<br/>      metric_name = string<br/>      namespace   = string<br/>      statistic   = optional(string, "Average")<br/>      threshold   = number<br/>      operator    = optional(string, "GreaterThanThreshold")<br/>      enabled     = optional(bool, true)<br/>    })), [])<br/><br/>    # Application type specific settings<br/>    application_type = optional(string, "web") # web, api, background, batch<br/>  })</pre> | `{}` | no |
| <a name="input_security_group_ids"></a> [security\_group\_ids](#input\_security\_group\_ids) | List of security group IDs for the VPC connector | `list(string)` | `[]` | no |
| <a name="input_service_name"></a> [service\_name](#input\_service\_name) | Name of the App Runner service | `string` | n/a | yes |
| <a name="input_sns_topic_arn"></a> [sns\_topic\_arn](#input\_sns\_topic\_arn) | ARN of an existing SNS topic for alarm notifications | `string` | `null` | no |
| <a name="input_sns_topic_name"></a> [sns\_topic\_name](#input\_sns\_topic\_name) | Name of the SNS topic for alarm notifications | `string` | `null` | no |
| <a name="input_source_code_config"></a> [source\_code\_config](#input\_source\_code\_config) | Source code deployment configuration | <pre>object({<br/>    repository_url = string<br/>    source_code_version = object({<br/>      type  = string<br/>      value = string<br/>    })<br/>    connection_provider = optional(string, null)<br/>    connection_name     = optional(string, null)<br/>    code_configuration = object({<br/>      configuration_source          = string<br/>      runtime                       = optional(string, null)<br/>      build_command                 = optional(string, null)<br/>      start_command                 = optional(string, null)<br/>      runtime_environment_variables = optional(map(string), {})<br/>      runtime_environment_secrets   = optional(map(string), {})<br/>    })<br/>  })</pre> | `null` | no |
| <a name="input_source_type"></a> [source\_type](#input\_source\_type) | Type of source for the App Runner service. Valid values are 'container' or 'source\_code' | `string` | `"container"` | no |
| <a name="input_subnet_ids"></a> [subnet\_ids](#input\_subnet\_ids) | List of subnet IDs for the VPC connector | `list(string)` | `[]` | no |
| <a name="input_tags"></a> [tags](#input\_tags) | A map of tags to assign to the resource | `map(string)` | `{}` | no |
| <a name="input_timeout"></a> [timeout](#input\_timeout) | The time, in seconds, to wait for a health check response before deciding it failed | `number` | `2` | no |
| <a name="input_unhealthy_threshold"></a> [unhealthy\_threshold](#input\_unhealthy\_threshold) | The number of consecutive checks that must fail before App Runner decides that the service is unhealthy | `number` | `5` | no |
| <a name="input_vpc_connector_arn"></a> [vpc\_connector\_arn](#input\_vpc\_connector\_arn) | ARN of an existing VPC connector | `string` | `null` | no |
| <a name="input_vpc_connector_name"></a> [vpc\_connector\_name](#input\_vpc\_connector\_name) | Name of the VPC connector | `string` | `null` | no |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_alarm_arns"></a> [alarm\_arns](#output\_alarm\_arns) | The ARNs of the CloudWatch alarms |
| <a name="output_app_runner_role_arn"></a> [app\_runner\_role\_arn](#output\_app\_runner\_role\_arn) | The ARN of the App Runner IAM role |
| <a name="output_app_runner_role_name"></a> [app\_runner\_role\_name](#output\_app\_runner\_role\_name) | The name of the App Runner IAM role |
| <a name="output_auto_scaling_configuration_arn"></a> [auto\_scaling\_configuration\_arn](#output\_auto\_scaling\_configuration\_arn) | The ARN of the auto scaling configuration |
| <a name="output_auto_scaling_configuration_name"></a> [auto\_scaling\_configuration\_name](#output\_auto\_scaling\_configuration\_name) | The name of the auto scaling configuration |
| <a name="output_cloudwatch_dashboard_url"></a> [cloudwatch\_dashboard\_url](#output\_cloudwatch\_dashboard\_url) | The URL of the CloudWatch dashboard |
| <a name="output_cloudwatch_logs_iam_policy_id"></a> [cloudwatch\_logs\_iam\_policy\_id](#output\_cloudwatch\_logs\_iam\_policy\_id) | The ID of the IAM policy for CloudWatch logs |
| <a name="output_cloudwatch_logs_iam_policy_name"></a> [cloudwatch\_logs\_iam\_policy\_name](#output\_cloudwatch\_logs\_iam\_policy\_name) | The name of the IAM policy for CloudWatch logs |
| <a name="output_connection_arn"></a> [connection\_arn](#output\_connection\_arn) | The ARN of the App Runner connection |
| <a name="output_connection_name"></a> [connection\_name](#output\_connection\_name) | The name of the App Runner connection |
| <a name="output_custom_domain_certificate_validation_records"></a> [custom\_domain\_certificate\_validation\_records](#output\_custom\_domain\_certificate\_validation\_records) | The certificate validation records for the custom domain |
| <a name="output_custom_domain_dns_target"></a> [custom\_domain\_dns\_target](#output\_custom\_domain\_dns\_target) | The DNS target for the custom domain |
| <a name="output_custom_domain_name"></a> [custom\_domain\_name](#output\_custom\_domain\_name) | The custom domain name |
| <a name="output_custom_domain_status"></a> [custom\_domain\_status](#output\_custom\_domain\_status) | The status of the custom domain association |
| <a name="output_instance_role_arn"></a> [instance\_role\_arn](#output\_instance\_role\_arn) | The ARN of the App Runner instance IAM role |
| <a name="output_instance_role_name"></a> [instance\_role\_name](#output\_instance\_role\_name) | The name of the App Runner instance IAM role |
| <a name="output_service_arn"></a> [service\_arn](#output\_service\_arn) | The App Runner service ARN |
| <a name="output_service_id"></a> [service\_id](#output\_service\_id) | The App Runner service ID |
| <a name="output_service_name"></a> [service\_name](#output\_service\_name) | The App Runner service name |
| <a name="output_service_url"></a> [service\_url](#output\_service\_url) | The App Runner service URL |
| <a name="output_sns_topic_arn"></a> [sns\_topic\_arn](#output\_sns\_topic\_arn) | The ARN of the SNS topic for alarm notifications |
| <a name="output_status"></a> [status](#output\_status) | The current state of the App Runner service |
| <a name="output_vpc_connector_arn"></a> [vpc\_connector\_arn](#output\_vpc\_connector\_arn) | The ARN of the VPC connector |
| <a name="output_vpc_connector_id"></a> [vpc\_connector\_id](#output\_vpc\_connector\_id) | The ID of the VPC connector |
<!-- END_TF_DOCS -->
