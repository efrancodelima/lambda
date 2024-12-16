resource "aws_apigatewayv2_api" "tf_api_gateway" {
  name                         = "lanchonete-api-gateway"
  protocol_type                = "HTTP"
  route_selection_expression   = "$request.method $request.path"
  api_key_selection_expression = "$request.header.x-api-key"
  disable_execute_api_endpoint = false
}

output "api_endpoint" {
  value = aws_apigatewayv2_api.tf_api_gateway.api_endpoint
  description = "Endpoint URL of the API Gateway"
}
