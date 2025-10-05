# Web Application with Monitoring Example

This example demonstrates deploying a web application to AWS App Runner with comprehensive monitoring, alarms, and observability features.

## What This Example Creates

- **App Runner Service**: Deploys a web application using the `hello-app-runner` container
- **IAM Role**: Instance role with ECR access and X-Ray tracing permissions
- **CloudWatch Alarms**: Monitors response time, error rate, CPU, memory, and active instances
- **SNS Topic**: For alarm notifications via email
- **CloudWatch Dashboard**: Visual monitoring dashboard
- **X-Ray Tracing**: Distributed tracing for performance insights

## Architecture

```plaintext
┌─────────────────┐    ┌──────────────────┐    ┌─────────────────┐
│   ECR Public    │───▶│   App Runner     │───▶│  CloudWatch     │
│   Container     │    │   Service        │    │  Monitoring     │
└─────────────────┘    └──────────────────┘    └─────────────────┘
                                │                        │
                                ▼                        ▼
                       ┌─────────────────┐    ┌─────────────────┐
                       │   AWS X-Ray     │    │   SNS Topic     │
                       │   Tracing       │    │   (Email)       │
                       └─────────────────┘    └─────────────────┘
```

## Usage

1. **Initialize Terraform**:

   ```bash
   terraform init
   ```

2. **Update email address**:
   - Edit `main.tf` and replace `admin@example.com` with your email address
   - This will be used for alarm notifications

3. **Review the plan**:

   ```bash
   terraform plan
   ```

4. **Deploy the application**:

   ```bash
   terraform apply
   ```

5. **Access your application**:
   - The output will show the App Runner service URL
   - Visit the URL in your browser to see the application

6. **Check monitoring**:
   - Visit the CloudWatch dashboard URL from the outputs
   - Check your email for SNS topic subscription confirmation

## Monitoring Features

### CloudWatch Alarms

- **Response Time**: Alerts when average response time exceeds 2 seconds
- **Error Rate**: Alerts when 5xx error rate exceeds 10%
- **CPU Utilization**: Alerts when CPU usage exceeds 70%
- **Memory Utilization**: Alerts when memory usage exceeds 80%
- **Active Instances**: Alerts when active instances drop below 1

### CloudWatch Dashboard

- Real-time metrics visualization
- Service logs display
- Performance trends

### X-Ray Tracing

- Distributed request tracing
- Performance bottleneck identification
- Service map visualization

### SNS Notifications

- Email alerts for all alarms
- Configurable notification endpoints

## Configuration

- **Instance Size**: 1 vCPU, 2 GB RAM
- **Health Check**: HTTP GET on `/` path
- **Monitoring**: Full CloudWatch integration
- **Tracing**: AWS X-Ray enabled
- **Notifications**: Email-based alerts

## Outputs

- `web_app_url`: The URL of your deployed web application
- `web_app_arn`: The ARN of the App Runner service
- `monitoring_dashboard_url`: CloudWatch dashboard URL
- `sns_topic_arn`: SNS topic ARN for notifications
- `alarm_arns`: ARNs of all CloudWatch alarms

## Cleanup

To destroy the resources:

```bash
terraform destroy
```

## Notes

- Remember to confirm the SNS email subscription
- X-Ray tracing may take a few minutes to show data
- Alarms will only trigger after the service has been running for a while
- Dashboard data will populate as the service receives traffic

## Troubleshooting

1. **No alarm notifications**: Check SNS topic subscription status
2. **X-Ray traces not appearing**: Ensure your application supports X-Ray tracing
3. **Dashboard empty**: Wait for metrics to accumulate (5-15 minutes)
4. **High false alarms**: Adjust thresholds in the `alarm_thresholds` block
