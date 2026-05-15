# EC2 Instance resource
# All values come from variables — nothing is hardcoded
resource "aws_instance" "this" {
  ami                    = var.ami_id
  instance_type          = var.instance_type
  subnet_id              = var.subnet_id
  vpc_security_group_ids = var.security_group_ids

  # merge() combines the Name tag with any additional tags passed in
  tags = merge(var.tags, {
    Name = var.instance_name
  })
}