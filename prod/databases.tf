resource "aws_security_group" "todo_db_sg" {
  name        = "todo-db-sg"
  description = "Security group for app databases"
  vpc_id      = aws_vpc.todo_vpc.id
  ingress {
    from_port       = 3306
    protocol        = "tcp"
    to_port         = 3306
    security_groups = [aws_security_group.todo_web_sg.id]
    description     = "Allow DB traffic only from the web security group"
  }
  tags = {
    Name = "todo_db_sg"
  }
}

resource "aws_db_instance" "todo_database" {
  db_name                = "todo"
  engine                 = "mysql"
  allocated_storage      = 5
  instance_class         = "db.t2.micro"
  skip_final_snapshot    = true
  username               = var.database_username
  password               = var.database_password
  db_subnet_group_name   = aws_db_subnet_group.todo_db_subnet_group.name
  vpc_security_group_ids = [aws_security_group.todo_db_sg.id]
}