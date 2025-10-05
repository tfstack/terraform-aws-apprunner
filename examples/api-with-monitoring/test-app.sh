#!/bin/bash

# Application Testing Script for Hello App Runner Service
# This script demonstrates basic application functionality and monitoring

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
BLUE='\033[0;34m'
YELLOW='\033[1;33m'
NC='\033[0m' # No Color

# Get the API URL from Terraform output and ensure HTTPS
APP_URL=$(terraform output -raw api_url 2>/dev/null)
# Add https:// protocol since App Runner requires HTTPS
if [[ "$APP_URL" != http* ]]; then
    APP_URL="https://${APP_URL}"
fi

if [ -z "$APP_URL" ]; then
    echo -e "${RED}Error: Could not get API URL from Terraform output${NC}"
    echo "Make sure you've run 'terraform apply' and the service is deployed"
    exit 1
fi

echo -e "${BLUE}Testing Application at: ${APP_URL}${NC}"
echo "================================================"

# Function to test an endpoint
test_endpoint() {
    local method=$1
    local endpoint=$2
    local description=$3

    echo -e "\n${YELLOW}Testing: ${description}${NC}"
    echo "Endpoint: ${method} ${endpoint}"

    response=$(curl -s -w "\nHTTP_CODE:%{http_code}" -X "$method" \
        "${APP_URL}${endpoint}")

    http_code=$(echo "$response" | grep "HTTP_CODE:" | cut -d: -f2)
    body=$(echo "$response" | sed '/HTTP_CODE:/d')

    if [[ "$http_code" =~ ^2[0-9][0-9]$ ]]; then
        echo -e "${GREEN}✓ Success (HTTP $http_code)${NC}"
        echo "Response: $(echo "$body" | head -c 200)..."
    else
        echo -e "${RED}✗ Failed (HTTP $http_code)${NC}"
        echo "Response: $body"
    fi
}

# Test basic endpoints (hello-app-runner only serves root path)
test_endpoint "GET" "/" "Main Application Page"

# Test with different headers
echo -e "\n${YELLOW}Testing with different headers:${NC}"
curl -s -H "User-Agent: Test-Script" "${APP_URL}/" > /dev/null && echo -e "${GREEN}✓ Custom User-Agent${NC}" || echo -e "${RED}✗ Custom User-Agent failed${NC}"

curl -s -H "Accept: application/json" "${APP_URL}/" > /dev/null && echo -e "${GREEN}✓ JSON Accept Header${NC}" || echo -e "${RED}✗ JSON Accept Header failed${NC}"

# Test response time
echo -e "\n${YELLOW}Testing response time:${NC}"
response_time=$(curl -s -w "%{time_total}" -o /dev/null "${APP_URL}/")
echo -e "${BLUE}Response time: ${response_time}s${NC}"

echo -e "\n${BLUE}================================================"
echo "Application Testing Complete!"
echo "Check the CloudWatch dashboard for metrics and logs"
echo "================================================${NC}"
