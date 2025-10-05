run "app_runner_service_creation" {
  command = plan

  variables {
    service_name = "test-app-runner-service"
    source_type  = "container"
    container_config = {
      image_identifier           = "public.ecr.aws/aws-containers/hello-app-runner:latest"
      image_repository_type      = "ECR_PUBLIC"
      create_image_configuration = true
      port                       = "8080"
    }
  }

  assert {
    condition     = aws_apprunner_service.this.service_name == "test-app-runner-service"
    error_message = "App Runner service name should be 'test-app-runner-service'"
  }

  assert {
    condition     = aws_apprunner_service.this.instance_configuration[0].cpu == "1024"
    error_message = "App Runner service CPU should be 1024"
  }

  assert {
    condition     = aws_apprunner_service.this.instance_configuration[0].memory == "2048"
    error_message = "App Runner service memory should be 2048"
  }
}

run "app_runner_health_check" {
  command = plan

  variables {
    service_name = "test-app-runner-service"
    source_type  = "container"
    container_config = {
      image_identifier           = "public.ecr.aws/aws-containers/hello-app-runner:latest"
      image_repository_type      = "ECR_PUBLIC"
      create_image_configuration = true
      port                       = "8080"
    }
    health_check_path = "/"
  }

  assert {
    condition     = aws_apprunner_service.this.health_check_configuration[0].path == "/"
    error_message = "Health check path should be '/'"
  }

  assert {
    condition     = aws_apprunner_service.this.health_check_configuration[0].protocol == "HTTP"
    error_message = "Health check protocol should be 'HTTP'"
  }
}

run "app_runner_iam_role" {
  command = plan

  variables {
    service_name = "test-app-runner-service"
    source_type  = "container"
    container_config = {
      image_identifier           = "public.ecr.aws/aws-containers/hello-app-runner:latest"
      image_repository_type      = "ECR_PUBLIC"
      create_image_configuration = true
      port                       = "8080"
    }
    create_instance_role = true
  }

  assert {
    condition     = var.create_instance_role == true
    error_message = "Instance role should be created"
  }
}
