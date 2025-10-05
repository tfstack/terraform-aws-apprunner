# API Service with Monitoring Example

This example demonstrates deploying an API service to AWS App Runner with comprehensive monitoring, using the AWS hello-app-runner container as a simple API demonstration.

## What This Example Creates

- **App Runner Service**: Deploys hello-app-runner API service using ECR Public
- **IAM Role**: Instance role with ECR access and X-Ray tracing permissions
- **CloudWatch Alarms**: Monitors response time, error rate, CPU, memory, and active instances
- **SNS Topic**: For alarm notifications via email
- **CloudWatch Dashboard**: Visual monitoring dashboard with API-specific metrics
- **X-Ray Tracing**: Distributed tracing for API performance insights

## Architecture

```plaintext
┌─────────────────┐    ┌──────────────────┐    ┌─────────────────┐
│   ECR Public    │───▶│   App Runner     │───▶│  CloudWatch     │
│   Hello App     │    │   Service        │    │  Monitoring     │
└─────────────────┘    └──────────────────┘    └─────────────────┘
                                │                        │
                                ▼                        ▼
                       ┌─────────────────┐    ┌─────────────────┐
                       │   AWS X-Ray     │    │   SNS Topic     │
                       │   Console       │    │   (Email)       │
                       └─────────────────┘    └─────────────────┘
```

## Hello App Runner API Features

The AWS hello-app-runner container provides a simple web application that demonstrates basic API functionality:

### **Core Endpoints**

- `GET /` - Main application page with basic information and health check

### **Application Features**

- **Web Interface**: Simple web application with basic HTML response
- **Health Monitoring**: Demonstrates health check functionality
- **Container Deployment**: Shows how containers work with App Runner
- **Monitoring Ready**: Generates logs and metrics for CloudWatch monitoring

## Usage

1. **Initialize Terraform**:

   ```bash
   terraform init
   ```

2. **Update email address**:
   - Edit `main.tf` and replace `api-team@example.com` with your email address
   - This will be used for alarm notifications

3. **Review the plan**:

   ```bash
   terraform plan
   ```

4. **Deploy the API service**:

   ```bash
   terraform apply
   ```

5. **Test the Application**:
   - The output will show the App Runner service URL
   - Test the application:

     ```bash
     # Test main page
     curl https://your-app-url.ap-southeast-1.awsapprunner.com/

     # Test with browser
     # Open the URL in your browser to see the web interface

     # Test the main endpoint (includes health check)
     curl https://your-app-url.ap-southeast-1.awsapprunner.com/

     # Or use the automated test script
     ./test-app.sh
     ```

6. **Check monitoring**:
   - Visit the CloudWatch dashboard URL from the outputs
   - Check your email for SNS topic subscription confirmation

## Monitoring Features

### CloudWatch Alarms (API-Optimized)

- **Response Time**: Alerts when average response time exceeds 500ms
- **Error Rate**: Alerts when 5xx error rate exceeds 2%
- **CPU Utilization**: Alerts when CPU usage exceeds 70%
- **Memory Utilization**: Alerts when memory usage exceeds 80%
- **Active Instances**: Alerts when active instances drop below 2

### CloudWatch Dashboard

- Real-time API metrics visualization
- Service logs display
- Custom metrics support

### X-Ray Tracing

- API request tracing (view in AWS X-Ray console)
- Performance bottleneck identification
- Service map visualization

### SNS Notifications

- Email alerts for all alarms
- Configurable notification endpoints

## Configuration

- **Instance Size**: 1 vCPU, 2 GB RAM
- **Health Check**: HTTP GET on `/` endpoint
- **Monitoring**: Full CloudWatch integration with API-specific thresholds
- **Tracing**: AWS X-Ray enabled
- **Notifications**: Email-based alerts

## API Testing Examples

### **Basic Application Testing**

```bash
# Test main application page
curl https://your-app-url.ap-southeast-1.awsapprunner.com/

# Test with different headers
curl -H "User-Agent: MyApp/1.0" https://your-app-url.ap-southeast-1.awsapprunner.com/
curl -H "Accept: application/json" https://your-app-url.ap-southeast-1.awsapprunner.com/

# Test response time
curl -w "Response time: %{time_total}s\n" -o /dev/null -s https://your-app-url.ap-southeast-1.awsapprunner.com/
```

### **Automated Testing**

```bash
# Use the provided test script
./test-app.sh
```

### **Browser Testing**

Open the URL in your browser to see the full web interface with:

- Welcome message
- Service deployment confirmation
- Links to AWS App Runner documentation
- Workshop and documentation references

## Outputs

- `api_url`: The URL of your deployed API service
- `api_arn`: The ARN of the App Runner service
- `monitoring_dashboard_url`: CloudWatch dashboard URL
- `sns_topic_arn`: SNS topic ARN for notifications

## Cleanup

To destroy the resources:

```bash
terraform destroy
```

## Notes

- The hello-app-runner container provides a simple demonstration application
- Remember to confirm the SNS email subscription
- X-Ray tracing is available in the AWS X-Ray console (not CloudWatch dashboard)
- Alarms are tuned for API workloads (lower response time thresholds)
- The service demonstrates App Runner monitoring capabilities

## Troubleshooting

1. **No alarm notifications**: Check SNS topic subscription status
2. **X-Ray traces not appearing**: Ensure your API calls are being made
3. **Dashboard empty**: Wait for metrics to accumulate (5-15 minutes)
4. **API not responding**: Check the health check endpoint `/`
