# Expose the security group ID so EC2 module can use it
output "sg_id" {
  description = "ID of the security group"
  value       = aws_security_group.this.id
}