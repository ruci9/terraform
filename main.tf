terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }
  }
}

# Configure the AWS Provider
provider "aws" {
  region = "ca-central-1"
  access_key = "AKIA2ZIONCXYCRMRI2WJ"
  secret_key = "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"
  
}

