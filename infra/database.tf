resource "aws_instance" "database" {
  ami                     = var.ami_id
  instance_type           = var.instance_type
  security_groups = [aws_security_group.databaseSG.name]
  key_name = var.key_name

  tags = {
    Name = "Database-Instance"
  }
}
