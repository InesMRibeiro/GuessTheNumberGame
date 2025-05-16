# -----------------------------------------------------------------------------
# main.tf
# -----------------------------------------------------------------------------
# This Terraform configuration file sets up the AWS provider for the "Guess the Number" project.
# It configures the AWS region and credentials using variables defined elsewhere.
# -----------------------------------------------------------------------------

provider "aws" {
  region = var.aws_region
  access_key = var.access_key
  secret_key = var.secret_key
}
