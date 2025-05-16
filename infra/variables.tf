# -----------------------------------------------------------------------------
# variables.tf
# -----------------------------------------------------------------------------
# This file contains input variable definitions for the Terraform configuration.
# Update these variables as needed to customize your infrastructure deployment.
# -----------------------------------------------------------------------------

# AMI
variable "ami_id" {
    description = "ID da ami do Ubuntu"
    type = string
    default = "ami-0c1ac8a41498c1a9c" 
}

#tipo de instância
variable "instance_type" {
    description = "Tipo de Instância do EC2"
    type = string
    default = "t3.micro"
  
}

#chave ssh
variable "key_name" {
    description = "Nome da chave SSH"
    type = string
    default = "RSA_key"
  
}