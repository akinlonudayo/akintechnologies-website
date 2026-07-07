# AkinTechnologies Website

![Project Architecture](images/architecture.drawio.svg)


A production website hosted entirely on AWS, with all infrastructure provisioned as code using Terraform and deployments automated through GitHub Actions.

## Overview

This project demonstrates an end-to-end cloud architecture for hosting and serving a static website with serverless backend capabilities — including an AI chat feature powered by **Amazon Bedrock (Claude 3 Sonnet)**. Every piece of infrastructure — from DNS to compute to messaging — is defined in version-controlled Terraform configuration, eliminating manual setup through the AWS Console.

The site is built on the following AWS services, each provisioned through its own Terraform configuration:

| Service | Purpose |
|---|---|
| **S3** | Static website asset storage |
| **CloudFront** | Global CDN for fast, secure content delivery |
| **Route 53** | DNS management and custom domain routing |
| **ACM** | SSL/TLS certificate management for HTTPS |
| **API Gateway** | REST API endpoint for backend functionality |
| **Lambda** | Serverless compute for backend logic |
| **DynamoDB** | NoSQL data storage |
| **SES** | Transactional email delivery |
| **IAM** | Least-privilege roles and permissions |
| **Amazon Bedrock** | Claude 3 Sonnet AI model for chat functionality |

## CI/CD

Deployments are automated via **GitHub Actions** (`.github/workflows`) on every push to `main`, following a fully automated pipeline with no manual steps:

```
1. Install Lambda dependencies (npm ci)
2. terraform init + terraform apply → provision / update infrastructure
3. Capture chat_api_url from Terraform output → inject into chat.html
4. aws s3 sync → deploy all frontend files to S3
5. CloudFront invalidation → serve latest version immediately
```

## Project Structure

```
.
├── .github/workflows/      # CI/CD pipeline definitions
├── lambda-chat/            # AI chat Lambda function
│   ├── index.js            # Main handler
│   ├── bedrock.js          # Amazon Bedrock API call logic
│   ├── history.js          # DynamoDB read/write helpers
│   └── package.json        # AWS SDK dependencies
├── acm.tf                  # SSL certificate configuration
├── apigateway.tf           # API Gateway setup (contact form)
├── apigateway-chat.tf      # POST /chat route for AI chat
├── cloudfront.tf           # CDN distribution
├── dynamodb.tf             # Database table definitions
├── dynamodb-chat.tf        # Chat history table with TTL
├── iam.tf                  # IAM roles and policies
├── iam-chat.tf             # IAM role + Bedrock permissions for chat Lambda
├── lambda.tf               # Contact form Lambda configuration
├── lambda-chat.tf          # AI chat Lambda configuration
├── outputs.tf              # Terraform outputs (chat API URL etc.)
├── providers.tf            # Terraform provider configuration
├── route53.tf              # DNS records
├── s3.tf                   # S3 bucket configuration
├── ses.tf                  # Email service configuration
├── bucket-policy.json      # S3 bucket access policy
├── bucket-policy-oac.json  # Origin Access Control policy for CloudFront
├── index.html              # Site homepage
├── chat.html               # AI chat interface
├── cloud-architecture-migration.html
├── cloud-cost-optimization.html
├── cloud-security.html
├── devops-automation.html
├── import.sh               # Resource import script
└── cleanup.sh              # Teardown/cleanup script
```

## Tech Stack

- **Infrastructure as Code:** Terraform (HCL)
- **CI/CD:** GitHub Actions
- **Frontend:** HTML, CSS, JavaScript
- **Backend:** Node.js (AWS Lambda)
- **AI:** Amazon Bedrock — Claude 3 Sonnet
- **Cloud Provider:** AWS

## Key Highlights

- 100% infrastructure-as-code deployment — no manual console configuration
- Fully automated CI/CD pipeline — push to main deploys everything end to end
- AI chat powered by Amazon Bedrock (Claude 3 Sonnet) with DynamoDB conversation history and 24hr TTL auto-expiry
- Serverless backend architecture (API Gateway + Lambda + DynamoDB)
- Global content delivery via CloudFront with custom domain and HTTPS
- Least-privilege IAM — separate roles scoped per Lambda function
- Includes teardown automation (`cleanup.sh`) for safe resource removal

## Getting Started

1. Clone the repository
2. Configure AWS credentials
3. Enable Amazon Bedrock model access in the AWS Console:
   - Navigate to **Amazon Bedrock → Model access**
   - Request access to **Claude 3 Sonnet** (`anthropic.claude-3-sonnet-20240229-v1:0`)
4. Install Lambda dependencies:
   ```bash
   cd lambda-chat && npm ci && cd ..
   ```
5. Initialize Terraform:
   ```bash
   terraform init
   ```
6. Review the planned changes:
   ```bash
   terraform plan
   ```
7. Apply the configuration:
   ```bash
   terraform apply
   ```
8. Retrieve the live chat API URL:
   ```bash
   terraform output chat_api_url
   ```

## Author

**Oladayo Akinlonu**
AWS Certified Solutions Architect – Associate
[GitHub](https://github.com/akinlonudayo) · [LinkedIn](www.linkedin.com/in/oladayoakinlonu)