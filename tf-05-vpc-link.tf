resource "aws_apigatewayv2_vpc_link" "tf_vpc_link" {
  name                = "lanchonete-vpc-link"
  security_group_ids  = [aws_security_group.tf_api_sg.id]
  subnet_ids          = [
    data.aws_subnet.tf_sub_priv_1.id,
    data.aws_subnet.tf_sub_priv_2.id
  ]

  depends_on = [
    aws_security_group.tf_api_sg
  ]
}
