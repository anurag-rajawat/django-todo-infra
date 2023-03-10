output "web_server_public_dns" {
  value       = aws_eip.todo_web_eip.public_dns
  description = "Public DNS of web server"
  depends_on  = [aws_eip.todo_web_eip]
}

output "web_server_public_ip" {
  value       = aws_eip.todo_web_eip.public_ip
  description = "Public IP address of web server"
  depends_on  = [aws_eip.todo_web_eip]
}

output "db_address" {
  value       = aws_db_instance.todo_database.address
  description = "The address of the database"
}

