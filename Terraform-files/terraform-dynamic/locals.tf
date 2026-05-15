locals {
  # Combined prefix used in all resource names
  name_prefix = "${var.project_name}-${var.environment}"

  # Common tags applied to ALL resources
  common_tags = {
    Project     = var.project_name
    Environment = var.environment
    ManagedBy   = "Terraform"
  }
}