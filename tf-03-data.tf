data "aws_lb" "tf_load_balancer" {
  name = "lanchonete-load-balancer"
}

data "aws_lb_listener" "tf_listener" {
  load_balancer_arn = data.aws_lb.tf_load_balancer.arn
  port = 8080
}

data "aws_vpc" "tf_vpc" {
  filter {
    name   = "tag:Name"
    values = ["lanchonete-vpc"]
  }
}
