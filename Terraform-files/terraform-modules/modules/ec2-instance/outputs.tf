# Expose the instance ID so callers can reference it
output "instance_id" {
  description = "ID of the EC2 instance"
  value       = aws_instance.this.id
}

# Expose public IP — useful for SSH access
output "public_ip" {
  description = "Public IP address of the EC2 instance"
  value       = aws_instance.this.public_ip
}

# Expose private IP — useful for internal communication
output "private_ip" {
  description = "Private IP address of the EC2 instance"
  value       = aws_instance.this.private_ip
}