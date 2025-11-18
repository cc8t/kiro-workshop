# IT Inventory Report - AWS us-east-1 Region

**Report Generated:** Tuesday, November 18, 2025 07:08 UTC

## Server Resources Summary

| Resource Type | Instance Type | vCPU | Memory (GB) | Public IP | Private IP | OS | Open Port(s) | IAM Role | Comments |
|---------------|---------------|------|-------------|-----------|------------|----|--------------|-----------|---------| 
| EC2 Instance | c5.2xlarge | 8 | 16 | 98.83.154.202 | 172.31.36.46 | Linux/UNIX | 80 (CloudFront only) | vscode-server-VSCodeInstanceProfile | ✅ Good: IMDSv2 enforced, monitoring enabled. ⚠️ Consider: Instance in default VPC, review CloudFront access patterns |
| EC2 Instance | t3.micro | 2 | 1 | 98.80.201.124 | 10.0.1.100 | Linux/UNIX | 22, 80 (restricted IP) | None | ⚠️ Warning: No IAM role attached, SSH/HTTP restricted to single IP. ✅ Good: IMDSv2 enforced |
| EC2 Instance | t3.micro | 2 | 1 | None | 10.0.3.31 | Linux/UNIX | 22, 80 (public access) | sample-app-EC2InstanceProfile | ⚠️ Warning: SSH open to 0.0.0.0/0, no public IP but accessible via load balancer. ✅ Good: IMDSv2 enforced, private subnet |
| EC2 Instance | t3.micro | 2 | 1 | None | 10.0.4.98 | Linux/UNIX | 22, 80 (public access) | sample-app-EC2InstanceProfile | ⚠️ Warning: SSH open to 0.0.0.0/0, no public IP but accessible via load balancer. ✅ Good: IMDSv2 enforced, private subnet |

## Detailed Instance Information

### VSCodeServer (i-0ab18376d22318d2b)
- **Name:** VSCodeServer
- **Instance Type:** c5.2xlarge
- **State:** running
- **Launch Time:** 2025-11-17 14:34:25 UTC
- **Availability Zone:** us-east-1d
- **VPC:** vpc-0b35021e2bb05896a (Default VPC)
- **Security Group:** vscode-server-SecurityGroup-cALvYU7y7wrk
- **Key Pair:** None
- **Monitoring:** Enabled

### Load Generator (i-04131f0cd7a72ca22)
- **Name:** sampleapp-load-generator
- **Instance Type:** t3.micro
- **State:** running
- **Launch Time:** 2025-11-17 14:42:38 UTC
- **Availability Zone:** us-east-1a
- **VPC:** vpc-028aeddae9e1e2244
- **Security Group:** sample-app-LoadGeneratorSecurityGroup-YV6rVtQIDQVI
- **Key Pair:** sampleapp-key-pair
- **Monitoring:** Disabled

### Web Server 1 (i-05958ea2ae9a406ad)
- **Name:** sampleapp-web-server
- **Instance Type:** t3.micro
- **State:** running
- **Launch Time:** 2025-11-17 14:40:26 UTC
- **Availability Zone:** us-east-1a
- **VPC:** vpc-028aeddae9e1e2244
- **Security Group:** sample-app-WebServerSecurityGroup-kXuEBc6ZjhwM
- **Key Pair:** sampleapp-key-pair
- **Auto Scaling Group:** sampleapp-web-server-asg
- **Monitoring:** Disabled

### Web Server 2 (i-0bb391e385de4b23e)
- **Name:** sampleapp-web-server
- **Instance Type:** t3.micro
- **State:** running
- **Launch Time:** 2025-11-17 14:40:26 UTC
- **Availability Zone:** us-east-1b
- **VPC:** vpc-028aeddae9e1e2244
- **Security Group:** sample-app-WebServerSecurityGroup-kXuEBc6ZjhwM
- **Key Pair:** sampleapp-key-pair
- **Auto Scaling Group:** sampleapp-web-server-asg
- **Monitoring:** Disabled

## Security Recommendations

### High Priority
1. **SSH Access:** Web servers have SSH (port 22) open to 0.0.0.0/0. Restrict to specific IP ranges or use AWS Systems Manager Session Manager.
2. **IAM Roles:** Load generator instance lacks an IAM role. Attach appropriate role for secure AWS service access.
3. **Monitoring:** Enable CloudWatch detailed monitoring for all instances to improve observability.

### Medium Priority
1. **Default VPC:** VSCode server is in the default VPC. Consider migrating to a custom VPC with proper subnet segmentation.
2. **Security Groups:** Review and implement least privilege access for security group rules.
3. **Key Management:** Ensure SSH key pairs are properly managed and rotated regularly.

### Best Practices Implemented ✅
- IMDSv2 enforced on all instances
- EBS encryption supported
- Auto Scaling Group configured for web servers
- Private subnets used for web servers
- CloudFormation managed infrastructure

## Resource Totals
- **Total Instances:** 4
- **Total vCPUs:** 14
- **Total Memory:** 20 GB
- **Public IPs:** 2
- **Private Subnets:** 2
- **Auto Scaling Groups:** 1
