resource "aws_apigatewayv2_authorizer" "tf_api_authorizer" {
  name = "api-authorization"
  api_id           = aws_apigatewayv2_api.tf_api_gateway.id
  
  identity_sources = ["$request.header.Authorization"]
  authorizer_type  = "JWT"
  
  jwt_configuration {
    audience = [var.up_client_id]
    issuer   = "https://cognito-idp.us-east-1.amazonaws.com/${var.user_pool_id}"
  }
  
  depends_on = [
    aws_apigatewayv2_api.tf_api_gateway
  ]
}


