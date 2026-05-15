terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }
  }

  # ADD THIS BACKEND BLOCK
  backend "s3" {
    bucket         = "terraweek-state-warrior-v2"    # Your bucket name
    key            = "dev/terraform.tfstate"      # Path inside the bucket
    region         = "ap-south-2"
    dynamodb_table = "terraweek-state-lock"       # Your DynamoDB table
    encrypt        = true                          # Encrypt state at rest
  }
}

provider "aws" {
  region = "ap-south-2"
}

resource "aws_vpc" "main" {
  cidr_block = "10.0.0.0/16"
  tags = {
    Name = "terraweek-state-demo"
  }
}

resource "aws_instance" "main" {
  ami           = "ami-024ebedf48d280810"
  instance_type = "t3.micro"
  tags = {
    Name = "terraweek-server"
  }
}

# This bucket already exists in AWS — we're going to import it
resource "aws_s3_bucket" "logs_bucket" {
  bucket = "terraweek-import-test-warrior"    # Must match the actual bucket name
}
