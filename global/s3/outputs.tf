output "s3_bucket_arn" {
  value       = aws_s3_bucket.todo_state.arn
  description = "The ARN of S3 bucket"
}

output "dynamodb_table_name" {
  value       = aws_dynamodb_table.todo_locks.name
  description = "The name of DynamoDB table"
}
