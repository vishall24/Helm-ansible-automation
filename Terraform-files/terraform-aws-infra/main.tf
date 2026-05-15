# ── VPC ──────────────────────────────────────────────────────────────
# The main container for all our networking resources
# 10.0.0.0/16 = 65,536 possible IP addresses in this network
resource "aws_vpc" "main" {
  cidr_block = "10.0.0.0/16"

  tags = {
    Name = "TerraWeek-VPC"
  }
}

# ── SUBNET ───────────────────────────────────────────────────────────
# A slice of the VPC — one logical segment
# 10.0.1.0/24 = 256 IPs in this subnet
# Notice: references aws_vpc.main.id — this is an IMPLICIT DEPENDENCY
resource "aws_subnet" "public" {
  vpc_id                  = aws_vpc.main.id          # Reference to VPC above
  cidr_block              = "10.0.1.0/24"
  map_public_ip_on_launch = true                     # Auto-assign public IP to instances

  tags = {
    Name = "TerraWeek-Public-Subnet"
  }
}

# ── INTERNET GATEWAY ─────────────────────────────────────────────────
# The door between your VPC and the internet
# Without this, nothing in your VPC can reach the internet
resource "aws_internet_gateway" "main" {
  vpc_id = aws_vpc.main.id                           # Attach to our VPC

  tags = {
    Name = "TerraWeek-IGW"
  }
}

# ── ROUTE TABLE ──────────────────────────────────────────────────────
# The traffic rules: where should packets go?
# 0.0.0.0/0 means "all traffic not destined for the local network"
# Send it to the internet gateway
resource "aws_route_table" "public" {
  vpc_id = aws_vpc.main.id

  route {
    cidr_block = "0.0.0.0/0"                        # All internet traffic
    gateway_id = aws_internet_gateway.main.id        # Goes through IGW
  }

  tags = {
    Name = "TerraWeek-RT"
  }
}

# ── ROUTE TABLE ASSOCIATION ───────────────────────────────────────────
# Link the route table to our subnet
# Without this, the subnet doesn't know which route table to use
resource "aws_route_table_association" "public" {
  subnet_id      = aws_subnet.public.id              # Our subnet
  route_table_id = aws_route_table.public.id         # Our route table
}





# ── SECURITY GROUP ────────────────────────────────────────────────────
# Virtual firewall — controls inbound and outbound traffic
resource "aws_security_group" "main" {
  name        = "TerraWeek-SG"
  description = "Allow SSH and HTTP"
  vpc_id      = aws_vpc.main.id              # Must be in our VPC

  # Allow SSH from anywhere (port 22)
  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]             # WARNING: open to internet — fine for learning
  }

  # Allow HTTP from anywhere (port 80)
  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  # Allow ALL outbound traffic
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"                       # -1 means all protocols
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "TerraWeek-SG"
  }
}

# ── EC2 INSTANCE ──────────────────────────────────────────────────────
# The actual server — placed inside our subnet with our security group
resource "aws_instance" "main" {
  ami                         = "ami-024ebedf48d280810"  # ubuntu, ap-south-2
  instance_type               = "t3.micro"               # Free tier
  subnet_id                   = aws_subnet.public.id     # Place in our public subnet
  vpc_security_group_ids      = [aws_security_group.main.id]  # Apply our SG
  associate_public_ip_address = true                     # Give it a public IP

  tags = {
    Name = "TerraWeek-Server"
  }

  lifecycle {
    create_before_destroy = true    # New instance created before old one is destroyed
  }
}


# ── S3 BUCKET FOR LOGS ───────────────────────────────────────────────
# No direct reference to EC2, but we want EC2 created first
# depends_on creates an EXPLICIT dependency
resource "aws_s3_bucket" "logs" {
  bucket = "terraweek-vishal-logs-2026"      # Change to something unique!

  depends_on = [aws_instance.main]           # Create EC2 first, then this bucket

  tags = {
    Name = "TerraWeek-Logs"
  }
}
