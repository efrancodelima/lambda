data "aws_vpc" "tf_vpc" {
  filter {
    name   = "tag:Name"
    values = ["lanchonete-vpc"]
  }
}

data "aws_subnet" "tf_sub_priv_1" {
  filter {
    name = "tag:Name"
    values = ["lanchonete-subnet-private1-us-east-1a"]
  }
}

data "aws_subnet" "tf_sub_priv_2" {
  filter {
    name = "tag:Name"
    values = ["lanchonete-subnet-private2-us-east-1b"]
  }
}

data "aws_lb" "tf_load_balancer" {
  name = "lanchonete-load-balancer"
}

data "aws_lb_listener" "tf_listener" {
  load_balancer_arn = data.aws_lb.tf_load_balancer.arn
  port = 8080
}

data "aws_lambda_function" "tf_lambda" {
  function_name = "teste"
}