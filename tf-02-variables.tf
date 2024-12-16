variable "aws_account_id" {
  description = "AWS account ID"
  type = string
}

variable "aws_region" {
  description = "AWS region"
  type = string
  default = "us-east-1"
}

variable "aws_zone_1" {
  description = "AWS AZ 1"
  type = string
  default = "us-east-1a"
}

variable "aws_zone_2" {
  description = "AWS AZ 2"
  type = string
  default = "us-east-1b"
}

# VPC e subnets
variable "vpc_id" {
  description = "O id da VPC"
  type = string
  default = "vpc-0b651ac3c75c4bd48"
}

variable "private_subnet_ids" {
  description = "A lista com os ids das subnets privadas"
  type = list(string)
  default = [
    "subnet-0af241860aeb1ef1d",   # private 1
    "subnet-03fb8f366403fba19"    # private 2
  ]
}

variable "public_subnet_ids" {
  description = "A lista com os ids das subnets públicas"
  type = list(string)
  default = [
    "subnet-0b19c7d0fd84e1a28",   # public 1
    "subnet-037488db47e7ed0b2"    # public 2
  ]
}

variable "user_pool_id" {
  description = "O id do user pool do Cognito"
  type = string
  default = "us-east-1_QFaugCzHu"
}

variable "client_id" {
  description = "O client id do Cognito"
  type = string
  default = "4j7fhutokfne6ad9mv5it0d4d7"
}

variable "listener_arn" {
  description = "O ARN do listener do load balancer da aplicação"
  type = string
  default = "4j7fhutokfne6ad9mv5it0d4d7"
}

# Banco de dados
variable "db_url" {
  description = "URL do banco de dados"
  type = string
}

variable "db_username" {
  description = "Nome de usuário do banco de dados"
  type = string
}

variable "db_password" {
  description = "Senha do banco de dados"
  type = string
}
