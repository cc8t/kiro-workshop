# Kiro Workshop - Sudoku Web Application Cost Analysis Estimate Report

## Service Overview

Kiro Workshop - Sudoku Web Application is a fully managed, serverless service that allows you to This project uses multiple AWS services.. This service follows a pay-as-you-go pricing model, making it cost-effective for various workloads.

## Pricing Model

This cost analysis estimate is based on the following pricing model:
- **ON DEMAND** pricing (pay-as-you-go) unless otherwise specified
- Standard service configurations without reserved capacity or savings plans
- No caching or optimization techniques applied

## Assumptions

- Low to moderate traffic web application (1,000-10,000 page views/month)
- Small static files (HTML, CSS, JS) totaling ~50KB per page load
- US East (N. Virginia) region pricing
- Standard ON DEMAND pricing model
- 30-day CloudWatch log retention
- 10% RUM session sampling rate
- Basic monitoring and alerting setup

## Limitations and Exclusions

- Data transfer costs between AWS regions
- Custom domain and SSL certificate costs
- Development and maintenance costs
- Backup and disaster recovery costs
- Advanced security features beyond basic setup

## Cost Breakdown

### Unit Pricing Details

| Service | Resource Type | Unit | Price | Free Tier |
|---------|--------------|------|-------|------------|
| Amazon S3 | Storage | GB/month | $0.023 | First 12 months: 5GB storage, 20,000 GET requests, 2,000 PUT requests free |
| Amazon S3 | Requests Get | 1,000 requests | $0.0004 | First 12 months: 5GB storage, 20,000 GET requests, 2,000 PUT requests free |
| Amazon S3 | Requests Put | 1,000 requests | $0.005 | First 12 months: 5GB storage, 20,000 GET requests, 2,000 PUT requests free |
| Amazon CloudFront | Data Transfer | GB (first 10TB) | $0.085 | First 12 months: 1TB data transfer out, 10M HTTP/HTTPS requests free |
| Amazon CloudFront | Requests | 10,000 HTTP requests | $0.0075 | First 12 months: 1TB data transfer out, 10M HTTP/HTTPS requests free |
| Amazon CloudWatch | Custom Metrics | metric/month | $0.30 | Always free: 10 custom metrics, 10 alarms, 1M API requests |
| Amazon CloudWatch | Alarms | alarm/month | $0.10 | Always free: 10 custom metrics, 10 alarms, 1M API requests |
| Amazon CloudWatch | Dashboard | dashboard/month | $3.00 | Always free: 10 custom metrics, 10 alarms, 1M API requests |
| Amazon CloudWatch | Logs Ingestion | GB ingested | $0.50 | Always free: 10 custom metrics, 10 alarms, 1M API requests |
| Amazon CloudWatch | Logs Storage | GB/month | $0.03 | Always free: 10 custom metrics, 10 alarms, 1M API requests |
| Amazon SNS | Publishes | 1,000,000 requests | $0.50 | First 12 months: 1M publishes, 100,000 HTTP deliveries, 1,000 email deliveries free |
| Amazon SNS | Email Notifications | 100,000 notifications | $2.00 | First 12 months: 1M publishes, 100,000 HTTP deliveries, 1,000 email deliveries free |
| Amazon CloudWatch RUM | Events | 100,000 events | $1.00 | First 100,000 events per month free |
| AWS X-Ray | Traces Recorded | 1,000,000 traces recorded | $5.00 | First 100,000 traces per month free |
| AWS X-Ray | Traces Retrieved | 1,000,000 traces retrieved | $5.00 | First 100,000 traces per month free |

### Cost Calculation

| Service | Usage | Calculation | Monthly Cost |
|---------|-------|-------------|-------------|
| Amazon S3 | Standard storage for static web files (~1MB total), minimal requests (Storage: 0.001 GB (1MB), Get Requests: 10,000 requests/month, Put Requests: 10 requests/month) | $0.023 × 0.001GB + $0.0004 × 10 + $0.005 × 0.01 = $0.02 | $0.02 |
| Amazon CloudFront | Global CDN for 10,000 requests/month, 500MB data transfer (Data Transfer: 0.5 GB/month, Requests: 10,000 requests/month) | $0.085 × 0.5GB + $0.0075 × 1 = $0.50 | $0.50 |
| Amazon CloudWatch | Basic monitoring, 2 alarms, 1 dashboard, 30-day log retention (Custom Metrics: 5 metrics, Alarms: 2 alarms, Dashboards: 1 dashboard, Log Ingestion: 0.1 GB/month, Log Storage: 0.1 GB/month) | Free tier covers basic usage, minimal overage = $2.50 | $2.50 |
| Amazon SNS | Email notifications for alerts (estimated 10 notifications/month) (Publishes: 10 requests/month, Email Notifications: 10 notifications/month) | Covered by free tier = $0.01 | $0.01 |
| Amazon CloudWatch RUM | Real User Monitoring with 10% sampling rate, 1,000 sessions/month (Events: 100,000 events/month (10% of 1M potential events)) | Covered by free tier for low traffic = $1.00 | $1.00 |
| AWS X-Ray | Performance tracing with 10% sampling rate (Traces Recorded: 1,000 traces/month, Traces Retrieved: 100 traces/month) | Covered by free tier for low traffic = $0.50 | $0.50 |
| **Total** | **All services** | **Sum of all calculations** | **$4.53/month** |

### Free Tier

Free tier information by service:
- **Amazon S3**: First 12 months: 5GB storage, 20,000 GET requests, 2,000 PUT requests free
- **Amazon CloudFront**: First 12 months: 1TB data transfer out, 10M HTTP/HTTPS requests free
- **Amazon CloudWatch**: Always free: 10 custom metrics, 10 alarms, 1M API requests
- **Amazon SNS**: First 12 months: 1M publishes, 100,000 HTTP deliveries, 1,000 email deliveries free
- **Amazon CloudWatch RUM**: First 100,000 events per month free
- **AWS X-Ray**: First 100,000 traces per month free

## Cost Scaling with Usage

The following table illustrates how cost estimates scale with different usage levels:

| Service | Low Usage | Medium Usage | High Usage |
|---------|-----------|--------------|------------|
| Amazon S3 | $0/month | $0/month | $0/month |
| Amazon CloudFront | $0/month | $0/month | $1/month |
| Amazon CloudWatch | $1/month | $2/month | $5/month |
| Amazon SNS | $0/month | $0/month | $0/month |
| Amazon CloudWatch RUM | $0/month | $1/month | $2/month |
| AWS X-Ray | $0/month | $0/month | $1/month |

### Key Cost Factors

- **Amazon S3**: Standard storage for static web files (~1MB total), minimal requests
- **Amazon CloudFront**: Global CDN for 10,000 requests/month, 500MB data transfer
- **Amazon CloudWatch**: Basic monitoring, 2 alarms, 1 dashboard, 30-day log retention
- **Amazon SNS**: Email notifications for alerts (estimated 10 notifications/month)
- **Amazon CloudWatch RUM**: Real User Monitoring with 10% sampling rate, 1,000 sessions/month
- **AWS X-Ray**: Performance tracing with 10% sampling rate

## Projected Costs Over Time

The following projections show estimated monthly costs over a 12-month period based on different growth patterns:

Base monthly cost calculation:

| Service | Monthly Cost |
|---------|-------------|
| Amazon S3 | $0.02 |
| Amazon CloudFront | $0.50 |
| Amazon CloudWatch | $2.50 |
| Amazon SNS | $0.01 |
| Amazon CloudWatch RUM | $1.00 |
| AWS X-Ray | $0.50 |
| **Total Monthly Cost** | **$4** |

| Growth Pattern | Month 1 | Month 3 | Month 6 | Month 12 |
|---------------|---------|---------|---------|----------|
| Steady | $4/mo | $4/mo | $4/mo | $4/mo |
| Moderate | $4/mo | $4/mo | $5/mo | $7/mo |
| Rapid | $4/mo | $5/mo | $7/mo | $12/mo |

* Steady: No monthly growth (1.0x)
* Moderate: 5% monthly growth (1.05x)
* Rapid: 10% monthly growth (1.1x)

## Detailed Cost Analysis

### Pricing Model

ON DEMAND


### Exclusions

- Data transfer costs between AWS regions
- Custom domain and SSL certificate costs
- Development and maintenance costs
- Backup and disaster recovery costs
- Advanced security features beyond basic setup

### Recommendations

#### Immediate Actions

- Leverage AWS Free Tier benefits for first 12 months to minimize costs
- Monitor CloudWatch usage to stay within free tier limits
- Optimize RUM sampling rate based on actual traffic patterns
- Set up billing alerts to track monthly spending



## Cost Optimization Recommendations

### Immediate Actions

- Leverage AWS Free Tier benefits for first 12 months to minimize costs
- Monitor CloudWatch usage to stay within free tier limits
- Optimize RUM sampling rate based on actual traffic patterns

### Best Practices

- Regularly review costs with AWS Cost Explorer
- Consider reserved capacity for predictable workloads
- Implement automated scaling based on demand

## Conclusion

By following the recommendations in this report, you can optimize your Kiro Workshop - Sudoku Web Application costs while maintaining performance and reliability. Regular monitoring and adjustment of your usage patterns will help ensure cost efficiency as your workload evolves.
