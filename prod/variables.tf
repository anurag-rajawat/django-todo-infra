variable "aws_region" {
  type        = string
  default     = "ap-south-1"
  description = "The region to deploy all resources"
}

variable "vpc_cidr_block" {
  type        = string
  default     = "10.0.0.0/16"
  description = "The CIDR block for VPC"
}

variable "subnet_count" {
  type        = map(number)
  description = "The number of public and private subnet"
  default     = {
    public  = 1,
    private = 2
  }
}

variable "public_subnet_cidr_blocks" {
  type        = list(string)
  description = "Available CIDR block for public access"
  default     = ["10.0.1.0/24", "10.0.2.0/24", "10.0.3.0/24", "10.0.4.0/24"]
}

variable "private_subnet_cidr_blocks" {
  type        = list(string)
  description = "Available CIDR blocks for private access"
  default     = ["10.0.101.0/24", "10.0.102.0/24", "10.0.103.0/24", "10.0.104.0/24"]
}

#variable "my_ip" {
#  type        = string
#  description = "My IP address to ssh instance"
#  sensitive   = true
#}

variable "database_username" {
  type        = string
  description = "Database master username"
  sensitive   = true
}

variable "database_password" {
  type        = string
  description = "Database master password"
  sensitive   = true
}

