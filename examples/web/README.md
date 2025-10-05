# Web Application Example

This example demonstrates deploying a simple web application to AWS App Runner using a container image from ECR Public registry.

## What This Example Creates

- **App Runner Service**: Deploys a web application using the `hello-app-runner` container
- **IAM Role**: Instance role with ECR access permissions
- **CloudWatch Logs**: Log group for application logs with 7-day retention
- **Health Checks**: HTTP health checks on the root path

## Architecture

```plaintext
┌─────────────────┐    ┌──────────────────┐    ┌─────────────────┐
│   ECR Public    │───▶│   App Runner     │───▶│  CloudWatch     │
│   Container     │    │   Service        │    │  Logs           │
└─────────────────┘    └──────────────────┘    └─────────────────┘
```

## Usage

1. **Initialize Terraform**:

   ```bash
   terraform init
   ```

2. **Review the plan**:

   ```bash
   terraform plan
   ```

3. **Deploy the application**:

   ```bash
   terraform apply
   ```

4. **Access your application**:
   - The output will show the App Runner service URL
   - Visit the URL in your browser to see the application

## Configuration

- **Instance Size**: 1 vCPU, 2 GB RAM
- **Health Check**: HTTP GET on `/` path
- **Log Retention**: 7 days
- **Repository**: ECR Public with image configuration

## Outputs

- `web_app_url`: The URL of your deployed web application
- `web_app_arn`: The ARN of the App Runner service
- `cloudwatch_log_group`: CloudWatch log group for application logs

## Cleanup

To destroy the resources:

```bash
terraform destroy
```

## Notes

- This example uses ECR Public with image configuration for port 8080
- Auto deployments are disabled for ECR Public repositories
- The application uses a simple hello-world container for demonstration
