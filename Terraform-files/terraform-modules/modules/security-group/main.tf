resource "aws_security_group" "this" {
  name        = var.sg_name
  description = "Security group managed by Terraform module"
  vpc_id      = var.vpc_id

  # dynamic block — creates ONE ingress rule for EACH port in ingress_ports
  dynamic "ingress" {
    for_each = var.ingress_ports    # Loop over [22, 80, 443]
    content {
      from_port   = ingress.value   # Current port in the loop
      to_port     = ingress.value
      protocol    = "tcp"
      cidr_blocks = ["0.0.0.0/0"]
    }
  }

  # Allow all outbound traffic
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = merge(var.tags, {
    Name = var.sg_name
  })
}