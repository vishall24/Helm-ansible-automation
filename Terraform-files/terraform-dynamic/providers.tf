terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0" # Allow 5.x but not 6.x
    }
  }
}

provider "aws" {
  region = var.region
}