provider "aws" {
  region = var.aws_region
  access_key = var.access_key
  secret_key = var.secret_key
}

resource "aws_vpc" "game_vpc" {
  cidr_block = "10.0.0.0/16"
}

resource "aws_subnet" "game_subnet" {
  vpc_id            = aws_vpc.game_vpc.id
  cidr_block        = "10.0.1.0/24" # Bloco menor dentro da VPC
  map_public_ip_on_launch = true

  tags = {
    Name = "gameSubnet"
  }
  
}



resource "aws_internet_gateway" "game_internet_gateway" {
  vpc_id = aws_vpc.game_vpc.id
}

resource "aws_route_table" "game_route_table" {
  vpc_id = aws_vpc.game_vpc.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.game_internet_gateway.id
  }

  tags = {
    Name = "gameRouteTable"
  }
}

resource "aws_route_table_association" "game_route_table_association" {
  subnet_id      = aws_subnet.game_subnet.id
  route_table_id = aws_route_table.game_route_table.id
}
