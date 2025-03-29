#!/bin/bash

# Atualiza os pacotes e instala dependências
sudo apt update -y
sudo apt install -y python3-pip git

# Clona o repositório (se não foi feito pelo Terraform)
cd /home/ubuntu
if [ ! -d "GuessTheNumberGame" ]; then
  git clone https://github.com/InesMRibeiro/GuessTheNumberGame.git
fi
cd GuessTheNumberGame/BackEnd

# Instala as dependências do Flask
pip3 install -r requirements.txt
