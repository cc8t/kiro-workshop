# Sudoku Web App - Terraform Infrastructure

This Terraform configuration deploys the Sudoku web application to AWS using:
- **Amazon S3**: Private bucket for hosting static files
- **Amazon CloudFront**: CDN for global content delivery

## Architecture

```
Internet → CloudFront → S3 (Private Bucket)
```

## Prerequisites

1. AWS CLI configured with appropriate credentials
2. Terraform installed (version 1.0+)

## Deployment

1. **Configure variables:**
   ```bash
   cp terraform.tfvars.example terraform.tfvars
   # Edit terraform.tfvars with your bucket name
   ```

2. **Initialize Terraform:**
   ```bash
   terraform init
   ```

3. **Plan deployment:**
   ```bash
   terraform plan
   ```

4. **Deploy infrastructure:**
   ```bash
   terraform apply
   ```

5. **Access your application:**
   The website URL will be displayed in the output.

## Resources Created

- S3 bucket (private) with public access blocked
- CloudFront distribution with Origin Access Control
- S3 bucket policy allowing CloudFront access
- Uploaded web application files

## Cleanup

To destroy all resources:
```bash
terraform destroy
```

## Security Features

- S3 bucket is private with all public access blocked
- CloudFront uses Origin Access Control (OAC) for secure S3 access
- HTTPS redirect enforced
- No direct S3 public access
