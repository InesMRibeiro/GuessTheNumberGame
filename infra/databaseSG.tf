# -----------------------------------------------------------------------------
# databaseSG.tf
# -----------------------------------------------------------------------------
# Security Groups
# Inbound and Outbound Rules for the Database Security Group
# -----------------------------------------------------------------------------
resource "aws_security_group" "databaseSG" {
  name        = "databaseSG"
  description = "Permitir HTTP e SSH"


    ingress {
        from_port   = 22
        to_port     = 22
        protocol    = "tcp"
        cidr_blocks = ["0.0.0.0/0"] 
    }

    ingress {
        from_port   = -1
        to_port     = -1
        protocol    = "icmp"  # allow ping (ICMP)
        cidr_blocks = ["0.0.0.0/0"]  # allow ping from anywhere (modify to something more restricted if necessary)
    }

      ingress {
        from_port   = 5000
        to_port     = 5000
        protocol    = "tcp"
        cidr_blocks = ["0.0.0.0/0"]  # allow access from any IP (adjust as necessary)
        }

      ingress {
        from_port   = 5432
        to_port     = 5432
        protocol    = "tcp"
        cidr_blocks = ["0.0.0.0/0"]  # allow access from any IP (adjust as necessary)
        }

    egress {
        from_port   = 0
        to_port     = 0
        protocol    = "-1"
        cidr_blocks = ["0.0.0.0/0"] 
    }

}