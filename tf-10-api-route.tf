resource "aws_apigatewayv2_route" "tf_api_route" {
  api_id              = aws_apigatewayv2_api.tf_api_gateway.id
  route_key           = "ANY /{proxy+}"

  authorization_type  = "JWT"
  authorizer_id       = aws_apigatewayv2_authorizer.tf_api_authorizer.id

  api_key_required    = false
  target              = "integrations/${aws_apigatewayv2_integration.tf_api_integration.id}"

  depends_on = [
    aws_apigatewayv2_api.tf_api_gateway,
    aws_apigatewayv2_authorizer.tf_api_authorizer,
    aws_apigatewayv2_integration.tf_api_integration
  ]
}
