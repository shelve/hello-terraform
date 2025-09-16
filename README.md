# dumb-terraform

A simple Terraform configuration for creating EC2 instances on AWS, designed to work with HCP Terraform (Terraform Cloud).

## Features

- Creates EC2 instances in the default VPC and subnet
- Uses the latest Amazon Linux 2 AMI
- Configures security groups with SSH, HTTP, and HTTPS access
- Includes user data script for basic instance setup
- Supports multiple instances
- Compatible with HCP Terraform

## Prerequisites

1. AWS account with appropriate permissions
2. HCP Terraform account
3. AWS credentials configured (via HCP Terraform environment variables)

## HCP Terraform Setup

1. Create a new workspace in HCP Terraform
2. Connect this repository to your workspace
3. Configure the following environment variables in your HCP Terraform workspace:
   - `AWS_ACCESS_KEY_ID` (sensitive)
   - `AWS_SECRET_ACCESS_KEY` (sensitive)
   - Optionally: `AWS_SESSION_TOKEN` (sensitive, if using temporary credentials)

4. Set Terraform variables in HCP Terraform (or use the defaults):
   - `aws_region`: AWS region (default: "us-east-1")
   - `project_name`: Project name for resource naming (default: "dumb-terraform")
   - `environment`: Environment name (default: "dev")
   - `instance_type`: EC2 instance type (default: "t3.micro")
   - `instance_count`: Number of instances (default: 1)
   - `key_pair_name`: AWS key pair name for SSH access (optional)
   - `allowed_cidr_blocks`: CIDR blocks for SSH access (default: ["0.0.0.0/0"])

5. Update the `terraform.tf` file to use your HCP Terraform organization name

## Local Development

If you want to run this locally:

1. Install Terraform
2. Copy `terraform.tfvars.example` to `terraform.tfvars` and customize
3. Configure AWS credentials
4. Comment out the HCP Terraform `cloud` block in `terraform.tf`
5. Run:
   ```bash
   terraform init
   terraform plan
   terraform apply
   ```

## What This Creates

- EC2 instances in the default VPC
- Security group with SSH (22), HTTP (80), and HTTPS (443) access
- Basic user data script that:
  - Updates the system
  - Installs Docker, AWS CLI, and other tools
  - Sets up a simple web page showing instance information
  - Starts Apache HTTP server

## Outputs

After successful deployment, you'll get:
- Instance IDs
- Public and private IP addresses
- Public DNS names
- Security group ID
- VPC and subnet IDs
- AMI ID used

## Security Considerations

- By default, SSH access is open to the world (0.0.0.0/0). Restrict `allowed_cidr_blocks` for production use
- Consider using AWS Systems Manager Session Manager instead of SSH for secure access
- The security group allows HTTP/HTTPS from anywhere, which is typical for web servers

## Cost Considerations

- Uses t3.micro instances by default (eligible for AWS free tier)
- Default configuration creates 1 instance
- Resources will incur AWS charges when running

## Cleanup

To destroy all resources:
- In HCP Terraform: Queue a destroy plan
- Locally: Run `terraform destroy`
