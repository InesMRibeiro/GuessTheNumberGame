# -----------------------------------------------------------------------------
# outputs.tf  
# -----------------------------------------------------------------------------
# This file contains output value definitions for the Terraform configuration.
# Update these outputs as needed to expose relevant infrastructure information.
# -----------------------------------------------------------------------------

output "backend-ip" {

    value = aws_instance.api_server.public_ip
}

output "frontend-ip" {

    value = aws_instance.frontend.public_ip
  
}

output "database-ip" {
  value = aws_instance.database.public_ip
}
