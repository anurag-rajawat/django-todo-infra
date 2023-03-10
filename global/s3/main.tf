terraform {
  required_version = ">= 1.3"
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 4.55.0"
    }
  }
#  Uncomment to configure S3 as backend
#  backend "s3" {
#    bucket = "todo-state"
#    # The filepath within the S3 bucket where the Terraform state file should be written.
#    key            = "global/s3/terraform.tfstate"
#    region         = "ap-south-1"
#    dynamodb_table = "todo-state-locks"
#    # Ensures that Terraform state will be encrypted at rest
#    encrypt = true
#  }
}

provider "aws" {
  region = "ap-south-1"
}

resource "aws_s3_bucket" "todo_state" {
  bucket = "todo-state"
  force_destroy = true
  # Prevent accidental deletion of this bucket
#  lifecycle {
#    prevent_destroy = true
#  }
}

resource "aws_s3_bucket_versioning" "enabled" {
  bucket = aws_s3_bucket.todo_state.id
  versioning_configuration {
    status = "Enabled"
  }
}

resource "aws_s3_bucket_server_side_encryption_configuration" "default" {
  bucket = aws_s3_bucket.todo_state.id
  rule {
    apply_server_side_encryption_by_default {
      sse_algorithm = "AES256"
    }
  }
}

# Explicitly block all public access to the S3 bucket
resource "aws_s3_bucket_public_access_block" "public_access" {
  bucket                  = aws_s3_bucket.todo_state.id
  block_public_acls       = true
  ignore_public_acls      = true
  block_public_policy     = true
  restrict_public_buckets = true
}

resource "aws_dynamodb_table" "todo_locks" {
  name         = "todo-state-locks"
  billing_mode = "PAY_PER_REQUEST"
  hash_key     = "LockID"
  attribute {
    name = "LockID"
    type = "S"
  }
}
