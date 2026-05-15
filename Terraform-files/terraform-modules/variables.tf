variable "region" {
  description = "AWS region"
  type        = string
  default     = "ap-south-2"
}

variable "project_name" {
  description = "Project name used in tags"
  type        = string
  default     = "terraweek"
}

variable "environment" {
  description = "Environment name"
  type        = string
  default     = "dev"
}