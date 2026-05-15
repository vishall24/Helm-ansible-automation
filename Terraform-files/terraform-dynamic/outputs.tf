# VPC ID
output "vpc_id" {
  description = "ID of the VPC"
  value       = aws_vpc.main.id
}

# Subnet ID
output "subnet_id" {
  description = "ID of the public subnet"
  value       = aws_subnet.public.id
}

# EC2 Instance ID
output "instance_id" {
  description = "ID of the EC2 instance"
  value       = aws_instance.main.id
}

# EC2 Public IP — most useful!
output "instance_public_ip" {
  description = "Public IP address of the EC2 instance"
  value       = aws_instance.main.public_ip
}

# EC2 Public DNS
output "instance_public_dns" {
  description = "Public DNS name of the EC2 instance"
  value       = aws_instance.main.public_dns
}

# Security Group ID
output "security_group_id" {
  description = "ID of the security group"
  value       = aws_security_group.main.id
}

output "ami_id_used" {
  description = "AMI ID that was automatically fetched"
  value       = data.aws_ami.amazon_linux.id
}