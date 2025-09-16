terraform {
  required_version = ">= 1.0"

  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }
  }

  # HCP Terraform configuration
  cloud {
    organization = "your-organization"

    workspaces {
      name = "dumb-terraform"
    }
  }
}