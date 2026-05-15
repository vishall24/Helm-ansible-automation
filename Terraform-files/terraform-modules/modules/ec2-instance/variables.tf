# The AMI ID to use for the instance
variable "ami_id" {
  description = "AMI ID for the EC2 instance"
  type        = string
}

# Instance type — defaults to t2.micro (free tier)
variable "instance_type" {
  description = "EC2 instance type"
  type        = string
  default     = "t3.micro"
}

# Which subnet to place the instance in
variable "subnet_id" {
  description = "Subnet ID where the instance will be created"
  type        = string
}

# List of security group IDs to attach
variable "security_group_ids" {
  description = "List of security group IDs to attach to the instance"
  type        = list(string)
}

# Name for the instance — used in the Name tag
variable "instance_name" {
  description = "Name of the EC2 instance"
  type        = string
}

# Extra tags to merge with the Name tag
variable "tags" {
  description = "Additional tags to apply to the instance"
  type        = map(string)
  default     = {}
}