resource "aws_instance" "api_server" {
  ami                     = var.ami_id
  instance_type           = var.instance_type
  subnet_id               = aws_subnet.game_subnet.id 
  vpc_security_group_ids  = [aws_security_group.backendSG.id] 
  key_name                = var.key_name
  associate_public_ip_address = true

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
