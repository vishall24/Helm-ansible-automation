# ── LOCALS ────────────────────────────────────────────────────────────
locals {
  common_tags = {
    Project     = var.project_name
    Environment = var.environment
    ManagedBy   = "Terraform"
  }
}

# ── DATA SOURCES ──────────────────────────────────────────────────────
# Fetch latest Amazon Linux 2 AMI automatically
data "aws_ami" "amazon_linux" {
  most_recent = true
  owners      = ["amazon"]

  filter {
    name   = "name"
    values = ["amzn2-ami-hvm-*-x86_64-gp2"]
  }

  filter {
    name   = "virtualization-type"
    values = ["hvm"]
  }
}

# ── NETWORKING ────────────────────────────────────────────────────────
# ── REGISTRY MODULE: VPC ──────────────────────────────────────────────
# Instead of 50 lines of VPC code, one module call!
# Downloads from: registry.terraform.io/modules/terraform-aws-modules/vpc/aws
module "vpc" {
  source  = "terraform-aws-modules/vpc/aws"
  version = "~> 5.0"

  name = "${var.project_name}-vpc"
  cidr = "10.0.0.0/16"

  azs            = ["ap-south-2a", "ap-south-2b"]
  public_subnets = ["10.0.1.0/24", "10.0.2.0/24"]
  private_subnets = ["10.0.3.0/24", "10.0.4.0/24"]

  enable_nat_gateway   = false
  enable_dns_hostnames = true

  tags = local.common_tags
}


# ── MODULE: SECURITY GROUP ────────────────────────────────────────────
# Calling our custom security group module
# source = path to the module folder
module "web_sg" {
  source = "./modules/security-group"

  vpc_id        = module.vpc.vpc_id  
  sg_name       = "${var.project_name}-web-sg"
  ingress_ports = [22, 80, 443]        # Dynamic block creates 3 rules
  tags          = local.common_tags
}

# ── MODULE: WEB SERVER ────────────────────────────────────────────────
# First call to EC2 module — creates the web server
module "web_server" {
  source = "./modules/ec2-instance"

  ami_id             = data.aws_ami.amazon_linux.id
  instance_type      = "t3.micro"
  subnet_id          = module.vpc.public_subnets[0] 
  security_group_ids = [module.web_sg.sg_id]    # Output from SG module
  instance_name      = "${var.project_name}-web"
  tags               = local.common_tags
}

# ── MODULE: API SERVER ────────────────────────────────────────────────
# Second call to SAME EC2 module — creates the API server
# Same module, different inputs = different instance
module "api_server" {
  source = "./modules/ec2-instance"

  ami_id             = data.aws_ami.amazon_linux.id
  instance_type      = "t3.micro"
  subnet_id          = module.vpc.public_subnets[0]
  security_group_ids = [module.web_sg.sg_id]    # Same security group
  instance_name      = "${var.project_name}-api"
  tags               = local.common_tags
}