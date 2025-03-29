# resource "aws_instance" "database" {
#   ami                     = var.ami_id
#   instance_type           = var.instance_type
#   security_groups = [aws_security_group.web_sg.name]
#   key_name = var.key_name

#   tags = {
#     Name = "Database-Instance"
#   }

#   # Usando user_data para instalar o PostgreSQL e configurar a base de dados
#   user_data = <<-EOF
#               #!/bin/bash
#               apt-get update -y
#               apt-get install -y postgresql postgresql-contrib
              
#               # Definir senha para o usuário postgres
#               sudo -u postgres psql -c "ALTER USER postgres WITH PASSWORD 'strongpassword';"

#               # Criar o banco de dados WINNERS
#               sudo -u postgres psql -c "CREATE DATABASE WINNERS;"

#               # Criar tabela para o scoreboard
#               sudo -u postgres psql -d WINNERS -c "
#               CREATE TABLE IF NOT EXISTS scoreboard (
#                   id SERIAL PRIMARY KEY,
#                   player_name VARCHAR(255) NOT NULL,
#                   win_date TIMESTAMP DEFAULT CURRENT_TIMESTAMP
#               );"

#               # Permitir conexões remotas
#               echo "host all all 0.0.0.0/0 md5" >> /etc/postgresql/12/main/pg_hba.conf
#               echo "listen_addresses = '*'" >> /etc/postgresql/12/main/postgresql.conf.sample

#               # Reiniciar o PostgreSQL
#               systemctl restart postgresql
#               EOF
# }
