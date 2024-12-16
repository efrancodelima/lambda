variable "aws_region" {
  description = "AWS region"
  type = string
  default = "us-east-1"
}

# VPC e subnets
variable "private_subnet_ids" {
  description = "A lista com os ids das subnets privadas"
  type = list(string)
  default = [
    "subnet-0af241860aeb1ef1d",   # private 1
    "subnet-03fb8f366403fba19"    # private 2
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
