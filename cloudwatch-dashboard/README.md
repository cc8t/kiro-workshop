# Sample App CloudWatch Monitoring Dashboard

This repository contains CloudWatch dashboard configurations for monitoring the `sample-app` workload deployed in AWS.

## Dashboard Overview

The dashboard provides comprehensive monitoring for a multi-tier application architecture including:

- **Application Load Balancer (ALB)** - Frontend load balancing
- **EC2 Instances** - Compute layer
- **DynamoDB** - Database layer
- **Auto Scaling Group** - Scalability management

## Key Metrics Monitored

### Application Load Balancer Metrics
- **Request Count**: Total number of requests processed
- **Target Response Time**: Average response time from targets
- **HTTP Status Codes**: 2XX (success) and 4XX (client errors)
- **Healthy/Unhealthy Host Count**: Target health status
- **Connection Metrics**: Active and new connections
- **Processed Bytes**: Data throughput

### EC2 Instance Metrics
- **CPU Utilization**: Processor usage percentage
- **Network Traffic**: Inbound and outbound network data
- **Status Checks**: Instance and system health checks
- **EBS Metrics**: Disk I/O performance (when applicable)

### DynamoDB Metrics
- **Capacity Utilization**: Read/write capacity consumption vs provisioned
- **Throttling Events**: Requests throttled due to capacity limits
- **Latency**: Response times for database operations

## AWS Best Practices Implemented

### 1. **Comprehensive Coverage**
- Monitors all critical components of the application stack
- Includes both performance and health metrics
- Covers error rates and success rates

### 2. **Appropriate Time Periods**
- Uses 5-minute periods for most metrics (300 seconds)
- Balances detail with performance

### 3. **Meaningful Visualizations**
- Time series charts for trend analysis
- Appropriate statistical functions (Sum, Average, Maximum)
- Logical grouping of related metrics

### 4. **Operational Focus**
- Prioritizes metrics that indicate user impact
- Includes capacity planning metrics
- Monitors error conditions and throttling

### 5. **Infrastructure as Code**
- Dashboard configuration stored as JSON
- CloudFormation template for reproducible deployments
- Parameterized for different environments

## Files Included

- `sample-app-dashboard.json` - Raw dashboard configuration
- `dashboard-template.yaml` - CloudFormation template
- `README.md` - This documentation

## Deployment Instructions

### Option 1: Direct AWS CLI Deployment
```bash
aws cloudwatch put-dashboard \
  --dashboard-name sample-app-monitoring \
  --dashboard-body file://sample-app-dashboard.json \
  --region us-east-1
```

### Option 2: CloudFormation Deployment
```bash
aws cloudformation deploy \
  --template-file dashboard-template.yaml \
  --stack-name sample-app-dashboard \
  --region us-east-1 \
  --parameter-overrides \
    LoadBalancerFullName=app/sampleapp-alb/388e264144a8d2e5 \
    TargetGroupFullName=targetgroup/sample-ALBTa-H7F01UABFXPV/f161235d96ae92c2 \
    InstanceId=i-04131f0cd7a72ca22 \
    DynamoDBTableName=sampleapp-Requests
```

## Customization

To adapt this dashboard for your environment:

1. **Update Resource Identifiers**: Modify the resource IDs in the configuration files
2. **Adjust Metrics**: Add or remove metrics based on your monitoring requirements
3. **Modify Time Periods**: Change the period parameter for different granularity
4. **Add Alarms**: Consider adding CloudWatch alarms for critical thresholds

## Monitoring Best Practices

### Key Performance Indicators (KPIs)
- **Availability**: Target health status, status check failures
- **Performance**: Response times, CPU utilization
- **Throughput**: Request count, network traffic
- **Errors**: HTTP 4XX/5XX rates, DynamoDB throttling

### Recommended Thresholds
- **CPU Utilization**: Alert if > 80% for sustained periods
- **Target Response Time**: Alert if > 2 seconds average
- **Unhealthy Hosts**: Alert if any targets are unhealthy
- **DynamoDB Throttling**: Alert on any throttling events

### Dashboard Usage Tips
- Review metrics during peak traffic periods
- Compare current performance to historical baselines
- Use the dashboard during incident response
- Regular capacity planning reviews

## Troubleshooting

### Common Issues
1. **No Data Points**: Verify resource IDs match your actual resources
2. **Permission Errors**: Ensure CloudWatch read permissions
3. **Missing Metrics**: Some metrics only appear after activity occurs

### Verification Commands
```bash
# List available metrics for ALB
aws cloudwatch list-metrics --namespace AWS/ApplicationELB --region us-east-1

# List available metrics for EC2
aws cloudwatch list-metrics --namespace AWS/EC2 --region us-east-1

# List available metrics for DynamoDB
aws cloudwatch list-metrics --namespace AWS/DynamoDB --region us-east-1
```

## Cost Considerations

- CloudWatch dashboards are free for the first 3 dashboards per account
- Additional dashboards cost $3.00 per month
- Metric storage and API calls may incur charges
- Consider data retention policies for cost optimization

## Next Steps

1. **Set up CloudWatch Alarms** for critical thresholds
2. **Create SNS Topics** for alert notifications
3. **Implement Custom Metrics** for application-specific monitoring
4. **Set up Log Insights** for application log analysis
5. **Consider AWS X-Ray** for distributed tracing
