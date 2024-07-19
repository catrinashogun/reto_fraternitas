provider "aws" {
  region = var.region
}

terraform {
  required_providers {
    aws = {
      source = "hashicorp/aws"
      version = "~> 3.0"
    }
  }

  backend "s3" {
    bucket         = "fraternitas-bucket"
    key            = "terraform/state"
    region         = "us-east-1"
    dynamodb_table = "fraternitas-locks"
    encrypt        = true
  }
}
