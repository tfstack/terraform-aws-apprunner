# IAM Resources
# IAM role for App Runner service
resource "aws_iam_role" "app_runner" {
  count = var.create_iam_role ? 1 : 0
  name  = var.iam_role_name != null ? var.iam_role_name : "${var.service_name}-app-runner"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = "sts:AssumeRole"
        Effect = "Allow"
        Principal = {
          Service = "build.apprunner.amazonaws.com"
        }
      }
    ]
  })

  tags = var.tags
}

# IAM role for App Runner instance
resource "aws_iam_role" "app_runner_instance" {
  count = var.create_instance_role ? 1 : 0
  name  = var.instance_role_name != null ? var.instance_role_name : "${var.service_name}-app-runner-instance"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = "sts:AssumeRole"
        Effect = "Allow"
        Principal = {
          Service = "tasks.apprunner.amazonaws.com"
        }
      }
    ]
  })

  tags = var.tags
}

# ECR access policy for App Runner instance role
resource "aws_iam_role_policy" "app_runner_instance_ecr_policy" {
  count = var.create_instance_role ? 1 : 0
  name  = "${var.service_name}-app-runner-instance-ecr-policy"
  role  = aws_iam_role.app_runner_instance[0].id

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect = "Allow"
        Action = [
          "ecr:GetDownloadUrlForLayer",
          "ecr:BatchGetImage",
          "ecr:DescribeImages",
          "ecr:GetAuthorizationToken",
          "ecr:BatchCheckLayerAvailability"
        ]
        Resource = "*"
      }
    ]
  })
}

# Custom policy for App Runner instance role
resource "aws_iam_role_policy" "app_runner_instance_custom" {
  count = var.create_instance_role && var.instance_role_policy != null ? 1 : 0
  name  = "${var.service_name}-app-runner-instance-custom-policy"
  role  = aws_iam_role.app_runner_instance[0].id

  policy = var.instance_role_policy
}

# CloudWatch Logs IAM Policy
resource "aws_iam_role_policy" "app_runner_instance_cloudwatch_logs" {
  count = var.create_instance_role ? 1 : 0
  name  = "${var.service_name}-app-runner-instance-cloudwatch-logs-policy"
  role  = aws_iam_role.app_runner_instance[0].id

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Sid    = "CloudWatchLogsWrite"
        Effect = "Allow"
        Action = [
          "logs:CreateLogGroup",
          "logs:CreateLogStream",
          "logs:PutLogEvents"
        ]
        Resource = "arn:aws:logs:${data.aws_region.current.region}:${data.aws_caller_identity.current.account_id}:log-group:/aws/apprunner/*"
      },
      {
        Sid    = "CloudWatchLogsRead"
        Effect = "Allow"
        Action = [
          "logs:DescribeLogGroups",
          "logs:DescribeLogStreams"
        ]
        Resource = "arn:aws:logs:${data.aws_region.current.region}:${data.aws_caller_identity.current.account_id}:log-group:/aws/apprunner/*"
      }
    ]
  })
}

# X-Ray IAM Policy
resource "aws_iam_role_policy" "app_runner_instance_xray" {
  count = var.create_instance_role && var.enable_xray_tracing ? 1 : 0
  name  = "${var.service_name}-app-runner-instance-xray-policy"
  role  = aws_iam_role.app_runner_instance[0].id

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Sid    = "XRayWrite"
        Effect = "Allow"
        Action = [
          "xray:PutTraceSegments",
          "xray:PutTelemetryRecords"
        ]
        Resource = "*"
      }
    ]
  })
}
