# String variable with a default value
variable "region" {
  description = "AWS region to deploy resources"
  type        = string
  default     = "ap-south-2"
}

# String variable — CIDR for the VPC
variable "vpc_cidr" {
  description = "CIDR block for the VPC"
  type        = string
  default     = "10.0.0.0/16"
}

# String variable — CIDR for the subnet
variable "subnet_cidr" {
  description = "CIDR block for the public subnet"
  type        = string
  default     = "10.0.1.0/24"
}

# String variable — EC2 instance type
variable "instance_type" {
  description = "EC2 instance type"
  type        = string
  default     = "t3.micro"
}

# String variable — NO default, so Terraform FORCES user to provide it
variable "project_name" {
  description = "Name of the project — used in all resource tags"
  type        = string
  # No default = Terraform will prompt you to enter this
}

# String variable — environment (dev, staging, prod)
variable "environment" {
  description = "Deployment environment"
  type        = string
  default     = "dev"
}

# List variable — ports to open in security group
variable "allowed_ports" {
  description = "List of ports to allow in security group"
  type        = list(number)
  default     = [22, 80, 443]
}

# Map variable — extra tags to add to all resources
variable "extra_tags" {
  description = "Extra tags to merge with common tags"
  type        = map(string)
  default     = {}
}