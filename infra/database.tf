
# -----------------------------------------------------------------------------
# database.tf
# -----------------------------------------------------------------------------
# This Terraform configuration provisions an AWS EC2 instance to serve as the database for the "Guess The Number" game.
# It uses a specified AMI, instance type, and SSH key, and attaches a security group for access control.
# -----------------------------------------------------------------------------

resource "aws_instance" "database" {
  ami                     = var.ami_id
  instance_type           = var.instance_type
  security_groups = [aws_security_group.databaseSG.name]
  key_name = var.key_name

  tags = {
    Name = "Database-Instance"
  }
}
