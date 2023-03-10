locals {
  http_port    = 80
  any_port     = 0
  tcp_protocol = "tcp"
  any_protocol = "-1"
  all_ips      = ["0.0.0.0/0"]
}

data "aws_ami" "ubuntu_22_04" {
  owners      = ["099720109477"]
  most_recent = true
  filter {
    name   = "name"
    values = ["ubuntu/images/hvm-ssd/ubuntu-jammy-22.04-amd64-server-*"]
  }
}

resource "aws_security_group" "todo_web_sg" {
  name        = "todo-web-sg"
  description = "Security group for web-servers"
  vpc_id      = aws_vpc.todo_vpc.id
  tags        = {
    Name = "todo_web_sg"
  }
}

resource "aws_security_group_rule" "inbound_http" {
  from_port         = local.http_port
  protocol          = local.tcp_protocol
  security_group_id = aws_security_group.todo_web_sg.id
  to_port           = local.http_port
  type              = "ingress"
  cidr_blocks       = local.all_ips
  description       = "Allow all inbound HTTP traffic"
}

resource "aws_security_group_rule" "ssh" {
  from_port         = 22
  protocol          = local.tcp_protocol
  security_group_id = aws_security_group.todo_web_sg.id
  to_port           = 22
  type              = "ingress"
  #  TODO: Update CIDR to allow ssh only from my computer
  cidr_blocks       = local.all_ips
  #  cidr_blocks       = ["${var.my_ip}/32"]
  #  description       = "Allow SSH only from my computer"
}

resource "aws_security_group_rule" "outbound" {
  from_port         = local.any_port
  protocol          = local.any_protocol
  security_group_id = aws_security_group.todo_web_sg.id
  to_port           = local.any_port
  type              = "egress"
  cidr_blocks       = local.all_ips
  description       = "Allow all outbound traffic"
}

resource "aws_instance" "todo_web" {
  ami                    = data.aws_ami.ubuntu_22_04.id
  instance_type          = "t2.micro"
  # TODO: Generate new key instead of hardcoding
  key_name               = "mumbai-zone"
  subnet_id              = aws_subnet.todo_public_subnet[0].id
  vpc_security_group_ids = [aws_security_group.todo_web_sg.id]
  tags                   = {
    Name = "todo_web"
  }
}

resource "aws_eip" "todo_web_eip" {
  instance = aws_instance.todo_web.id
  vpc      = true
  tags     = {
    Name = "todo_web_eip"
  }
}