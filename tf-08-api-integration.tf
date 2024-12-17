resource "aws_apigatewayv2_integration" "tf_api_integration" {
  api_id                 = aws_apigatewayv2_api.tf_api_gateway.id

  connection_id          = aws_apigatewayv2_vpc_link.tf_vpc_link.id
  connection_type        = "VPC_LINK"
  integration_method     = "ANY"
  integration_type       = "HTTP_PROXY"
  integration_uri        = data.aws_lb_listener.tf_listener.arn

  payload_format_version = "1.0"
  timeout_milliseconds   = 30000

  depends_on = [
    aws_apigatewayv2_api.tf_api_gateway,
    aws_apigatewayv2_vpc_link.tf_vpc_link
  ]
}
