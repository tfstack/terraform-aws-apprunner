# Service Configuration
variable "service_name" {
  description = "Name of the App Runner service"
  type        = string
}

variable "source_type" {
  description = "Type of source for the App Runner service. Valid values are 'container' or 'source_code'"
  type        = string
  default     = "container"
  validation {
    condition     = contains(["container", "source_code"], var.source_type)
    error_message = "Source type must be either 'container' or 'source_code'."
  }
}

variable "container_config" {
  description = "Container deployment configuration"
  type = object({
    image_identifier           = string
    image_repository_type      = optional(string, "ECR")
    create_image_configuration = optional(bool, true)
    port                       = optional(string, "8000")
    environment_variables      = optional(map(string), {})
    environment_secrets        = optional(map(string), {})
    start_command              = optional(string, null)
  })
  default = null
  validation {
    condition     = var.source_type == "container" ? var.container_config != null : true
    error_message = "container_config is required when source_type is 'container'."
  }
}

variable "source_code_config" {
  description = "Source code deployment configuration"
  type = object({
    repository_url = string
    source_code_version = object({
      type  = string
      value = string
    })
    connection_provider = optional(string, null)
    connection_name     = optional(string, null)
    code_configuration = object({
      configuration_source          = string
      runtime                       = optional(string, null)
      build_command                 = optional(string, null)
      start_command                 = optional(string, null)
      runtime_environment_variables = optional(map(string), {})
      runtime_environment_secrets   = optional(map(string), {})
    })
  })
  default = null
  validation {
    condition     = var.source_type == "source_code" ? var.source_code_config != null : true
    error_message = "source_code_config is required when source_type is 'source_code'."
  }
}


# Instance Configuration
variable "cpu" {
  description = "The number of CPU units reserved for each instance of your App Runner service"
  type        = string
  default     = "1024"
  validation {
    condition     = contains(["256", "512", "1024", "2048", "3072", "4096"], var.cpu)
    error_message = "CPU must be one of: 256, 512, 1024, 2048, 3072, 4096."
  }
}

variable "memory" {
  description = "The amount of memory, in MB or GB, reserved for each instance of your App Runner service"
  type        = string
  default     = "2048"
  validation {
    condition     = contains(["512", "1024", "2048", "3072", "4096", "5120", "6144", "7168", "8192"], var.memory)
    error_message = "Memory must be one of: 512, 1024, 2048, 3072, 4096, 5120, 6144, 7168, 8192."
  }
}

# Health Check Configuration
variable "health_check_path" {
  description = "The URL that App Runner should send a request to, using an HTTP GET request, to determine if this service is healthy"
  type        = string
  default     = "/"
}

variable "health_check_protocol" {
  description = "The protocol App Runner uses to perform health checks for your service"
  type        = string
  default     = "HTTP"
  validation {
    condition     = contains(["HTTP", "TCP"], var.health_check_protocol)
    error_message = "Health check protocol must be either HTTP or TCP."
  }
}

variable "healthy_threshold" {
  description = "The number of consecutive checks that must succeed before App Runner decides that the service is healthy"
  type        = number
  default     = 1
}

variable "interval" {
  description = "The time interval, in seconds, between health checks"
  type        = number
  default     = 5
}

variable "timeout" {
  description = "The time, in seconds, to wait for a health check response before deciding it failed"
  type        = number
  default     = 2
}

variable "unhealthy_threshold" {
  description = "The number of consecutive checks that must fail before App Runner decides that the service is unhealthy"
  type        = number
  default     = 5
}

# Auto Scaling Configuration
variable "auto_deployments_enabled" {
  description = "Whether continuous deployment from the source repository is enabled for the App Runner service"
  type        = bool
  default     = true
}

variable "create_auto_scaling_configuration" {
  description = "Whether to create an auto scaling configuration"
  type        = bool
  default     = false
}

variable "auto_scaling_configuration_name" {
  description = "Name of the auto scaling configuration"
  type        = string
  default     = null
}

variable "max_concurrency" {
  description = "The maximum number of concurrent requests that an instance processes"
  type        = number
  default     = 100
}

variable "max_size" {
  description = "The maximum number of instances that your service scales up to"
  type        = number
  default     = 10
}

variable "min_size" {
  description = "The minimum number of instances that your service scales down to"
  type        = number
  default     = 1
}

# IAM Configuration
variable "create_iam_role" {
  description = "Whether to create an IAM role for App Runner"
  type        = bool
  default     = false
}

variable "iam_role_name" {
  description = "Name of the IAM role for App Runner"
  type        = string
  default     = null
}

variable "create_instance_role" {
  description = "Whether to create an IAM role for App Runner instances"
  type        = bool
  default     = true
}

variable "instance_role_name" {
  description = "Name of the IAM role for App Runner instances"
  type        = string
  default     = null
}

variable "instance_role_arn" {
  description = "ARN of an existing IAM role for App Runner instances"
  type        = string
  default     = null
}

variable "instance_role_policy" {
  description = "Custom policy document for the App Runner instance role"
  type        = string
  default     = null
}

# Network Configuration
variable "egress_type" {
  description = "The type of egress configuration. Valid values are DEFAULT and VPC"
  type        = string
  default     = "DEFAULT"
  validation {
    condition     = contains(["DEFAULT", "VPC"], var.egress_type)
    error_message = "Egress type must be either DEFAULT or VPC."
  }
}

variable "vpc_connector_arn" {
  description = "ARN of an existing VPC connector"
  type        = string
  default     = null
}

variable "create_vpc_connector" {
  description = "Whether to create a VPC connector"
  type        = bool
  default     = false
}

variable "vpc_connector_name" {
  description = "Name of the VPC connector"
  type        = string
  default     = null
}

variable "subnet_ids" {
  description = "List of subnet IDs for the VPC connector"
  type        = list(string)
  default     = []
}

variable "security_group_ids" {
  description = "List of security group IDs for the VPC connector"
  type        = list(string)
  default     = []
}

# Custom Domain Configuration
variable "custom_domain" {
  description = "Custom domain name for the App Runner service"
  type        = string
  default     = null
}

variable "enable_www_subdomain" {
  description = "Whether to enable www subdomain for the custom domain"
  type        = bool
  default     = false
}

# Monitoring Configuration
variable "create_monitoring" {
  description = "Whether to create CloudWatch alarms and monitoring resources"
  type        = bool
  default     = false
}

variable "alarm_thresholds" {
  description = "Thresholds for CloudWatch alarms"
  type = object({
    # Response time alarm (milliseconds)
    response_time = optional(object({
      enabled            = optional(bool, true)
      threshold          = optional(number, 1000)
      period             = optional(number, 300)
      evaluation_periods = optional(number, 2)
    }), {})

    # Error rate alarm (percentage)
    error_rate = optional(object({
      enabled            = optional(bool, true)
      threshold          = optional(number, 5)
      period             = optional(number, 300)
      evaluation_periods = optional(number, 2)
    }), {})

    # CPU utilization alarm (percentage)
    cpu_utilization = optional(object({
      enabled            = optional(bool, true)
      threshold          = optional(number, 80)
      period             = optional(number, 300)
      evaluation_periods = optional(number, 2)
    }), {})

    # Memory utilization alarm (percentage)
    memory_utilization = optional(object({
      enabled            = optional(bool, true)
      threshold          = optional(number, 80)
      period             = optional(number, 300)
      evaluation_periods = optional(number, 2)
    }), {})

    # Active instances alarm (count)
    active_instances = optional(object({
      enabled            = optional(bool, true)
      threshold          = optional(number, 1)
      period             = optional(number, 300)
      evaluation_periods = optional(number, 2)
      operator           = optional(string, "LessThanThreshold")
    }), {})
  })
  default = {}
}

variable "sns_topic_arn" {
  description = "ARN of an existing SNS topic for alarm notifications"
  type        = string
  default     = null
}

variable "create_sns_topic" {
  description = "Whether to create an SNS topic for alarm notifications"
  type        = bool
  default     = false
}

variable "sns_topic_name" {
  description = "Name of the SNS topic for alarm notifications"
  type        = string
  default     = null
}

variable "alarm_email_addresses" {
  description = "List of email addresses to receive alarm notifications"
  type        = list(string)
  default     = []
}

variable "enable_xray_tracing" {
  description = "Whether to enable AWS X-Ray tracing for the App Runner service"
  type        = bool
  default     = false
}

variable "monitoring_config" {
  description = "Configuration for monitoring features"
  type = object({
    # Dashboard configuration
    create_dashboard = optional(bool, true)
    dashboard_widgets = optional(object({
      show_metrics = optional(bool, true)
      show_logs    = optional(bool, true)
    }), {})

    # Custom metrics
    custom_metrics = optional(list(object({
      metric_name = string
      namespace   = string
      statistic   = optional(string, "Average")
      threshold   = number
      operator    = optional(string, "GreaterThanThreshold")
      enabled     = optional(bool, true)
    })), [])

    # Application type specific settings
    application_type = optional(string, "web") # web, api, background, batch
  })
  default = {}
}

# Tags
variable "tags" {
  description = "A map of tags to assign to the resource"
  type        = map(string)
  default     = {}
}
