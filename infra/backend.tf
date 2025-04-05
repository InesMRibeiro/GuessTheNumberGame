resource "aws_instance" "api_server" {
  ami                     = var.ami_id
  instance_type           = var.instance_type
  key_name                = var.key_name
  security_groups        = [aws_security_group.backendSG.name] 

  tags = {
    Name = "Backend-Instance"
  }

  user_data = <<-EOF
              # Clona o repositório e configura o ambiente do Backend
              cd /home/ubuntu
              if [ ! -d "GuessTheNumberGame" ]; then
                git clone https://github.com/InesMRibeiro/GuessTheNumberGame.git
              fi
              EOF
}
