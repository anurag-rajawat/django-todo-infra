terraform {
  required_version = ">= 1.3.9"
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 4.55.0"
    }
  }
  backend "s3" {
    bucket         = "todo-state"
    key            = "prod/terraform.tfstate"
    region         = "ap-south-1"
    dynamodb_table = "todo-state-locks"
    encrypt        = true
  }
}

provider "aws" {
  region = var.aws_region
}