#EC2 instance running a backend

resource "aws_instance" "frontend" {
  ami                     = var.ami_id
  instance_type           = var.instance_type
  security_groups         = [aws_security_group.frontendSG.name] 
  key_name = var.key_name

  tags = {
    Name = "FrontEnd-Instance"
  }

  user_data = <<-EOF
              #!/bin/bash
              apt update -y
              apt install -y apache2
              systemctl start apache2
              systemctl enable apache2
              
              cd /var/www/html
              echo "<h1>Deploying Frontend</h1>" > index.html
              
              # Clonar o repositório
              if [ ! -d "GuessTheNumberGame" ]; then
                git clone https://github.com/InesMRibeiro/GuessTheNumberGame.git
              fi
              sudo cp GuessTheNumberGame/FrontEnd/* /var/www/html/
              EOF
}
