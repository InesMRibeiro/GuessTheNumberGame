# -----------------------------------------------------------------------------
# frontendSG.tf
# -----------------------------------------------------------------------------
# Security Groups
# Inbound and Outbound Rules for the Frontend Security Group
# -----------------------------------------------------------------------------

resource "aws_security_group" "frontendSG" {
  name        = "frontendSG"
  description = "Permitir HTTP e SSH"


    ingress {
        from_port   = 22
        to_port     = 22
        protocol    = "tcp"
        cidr_blocks = ["0.0.0.0/0"] 
    }

    ingress {
        from_port   = 80
        to_port     = 80
        protocol    = "tcp"
        cidr_blocks = ["0.0.0.0/0"] 
    }


    ingress {
        from_port   = -1
        to_port     = -1
        protocol    = "icmp"  # Permite ping (ICMP)
        cidr_blocks = ["0.0.0.0/0"]  # Permite ping de qualquer lugar (modifique para algo mais restrito, se necessário)
    }

      ingress {
        from_port   = 5000
        to_port     = 5000
        protocol    = "tcp"
        cidr_blocks = ["0.0.0.0/0"]  # Permitir acesso de qualquer IP (ajuste conforme necessário)
        }

    egress {
        from_port   = 0
        to_port     = 0
        protocol    = "-1"
        cidr_blocks = ["0.0.0.0/0"] 
    }

}