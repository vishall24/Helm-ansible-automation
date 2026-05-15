# Fetch the latest Amazon Linux 2 AMI automatically
# Works in ANY region — no more hardcoded AMI IDs!
data "aws_ami" "amazon_linux" {
  most_recent = true       # Get the newest one
  owners      = ["amazon"] # Only official Amazon AMIs

  filter {
    name   = "name"
    values = ["amzn2-ami-hvm-*-x86_64-gp2"] # Amazon Linux 2 pattern
  }

  filter {
    name   = "virtualization-type"
    values = ["hvm"]
  }

  filter {
    name   = "root-device-type"
    values = ["ebs"]
  }
}

# Fetch available Availability Zones in current region
data "aws_availability_zones" "available" {
  state = "available"
}