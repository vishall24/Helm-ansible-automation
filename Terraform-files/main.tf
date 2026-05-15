terraform {
  required_providers {
    aws = {
      source = "hashicorp/aws"
      version : "~> 5.0"
    }
  }
}

provider "aws" {
  region = "ap-south-2"
}

resource "aws_s3_bucket" "my_bucket" {
  bucket = "terraweek-2026-day-warrior-1"

  tags = {
    Name        = "TerraWeek Bucket"
    Environment = "Learning"
  }
}

resource "aws_instance" "my_ec2_ubuntu" {
  ami           = "ami-024ebedf48d280810"
  instance_type = "t3.micro"

  tags = {
    Name = "Terraweek-modified"
  }
}