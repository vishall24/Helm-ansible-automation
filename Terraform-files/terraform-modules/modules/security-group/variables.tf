# VPC where the security group will be created
variable "vpc_id" {
  description = "VPC ID where the security group will be created"
  type        = string
}

# Name for the security group
variable "sg_name" {
  description = "Name of the security group"
  type        = string
}

# List of ports to open for inbound traffic
# Dynamic block will create one ingress rule per port
variable "ingress_ports" {
  description = "List of ports to allow inbound"
  type        = list(number)
  default     = [22, 80, 443]
}

# Tags to apply to the security group
variable "tags" {
  description = "Tags to apply to the security group"
  type        = map(string)
  default     = {}
}