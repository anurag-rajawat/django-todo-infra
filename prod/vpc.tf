data "aws_availability_zones" "available" {
  state = "available"
}

resource "aws_vpc" "todo_vpc" {
  cidr_block           = var.vpc_cidr_block
  enable_dns_hostnames = true
  tags                 = {
    Name = "todo_vpc"
  }
}

resource "aws_subnet" "todo_public_subnet" {
  vpc_id            = aws_vpc.todo_vpc.id
  count             = var.subnet_count.public
  cidr_block        = var.public_subnet_cidr_blocks[count.index]
  availability_zone = data.aws_availability_zones.available.names[count.index]
  tags              = {
    Name = "todo_public_subnet_${count.index}"
  }
}

# RDS requires 2 subnets for a database and our database is going to be in the private subnet,
# that is why we need 2 private subnets
resource "aws_subnet" "todo_private_subnet" {
  count             = var.subnet_count.private
  vpc_id            = aws_vpc.todo_vpc.id
  cidr_block        = var.private_subnet_cidr_blocks[count.index]
  availability_zone = data.aws_availability_zones.available.names[count.index]
  tags              = {
    Name = "todo_private_subnet_${count.index}"
  }
}

resource "aws_db_subnet_group" "todo_db_subnet_group" {
  name        = "todo-db-subnet-group"
  description = "Subnet for database"
  # Since the db subnet group requires 2 or more subnets
  subnet_ids  = [for subnet in aws_subnet.todo_private_subnet : subnet.id]
}

resource "aws_internet_gateway" "todo_igw" {
  vpc_id = aws_vpc.todo_vpc.id
  tags   = {
    Name = "todo_igw"
  }
}

resource "aws_route_table" "todo_public_rt" {
  vpc_id = aws_vpc.todo_vpc.id
  # Since this is the public route table, it will need access to the internet.
  # So adding a route with a destination of 0.0.0.0/0 and targeting the internet
  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.todo_igw.id
  }
}

resource "aws_route_table_association" "public" {
  count          = var.subnet_count.public
  route_table_id = aws_route_table.todo_public_rt.id
  subnet_id      = aws_subnet.todo_public_subnet[count.index].id
}

resource "aws_route_table" "todo_private_rt" {
  vpc_id = aws_vpc.todo_vpc.id
}

resource "aws_route_table_association" "private" {
  count          = var.subnet_count.private
  route_table_id = aws_route_table.todo_private_rt.id
  subnet_id      = aws_subnet.todo_private_subnet[count.index].id
}