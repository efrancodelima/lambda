resource "aws_apigatewayv2_authorizer" "tf_api_authorizer" {
  name = "api-authorization"
  api_id           = aws_apigatewayv2_api.tf_api_gateway.id
  
  identity_sources = ["$request.header.Authorization"]
  authorizer_type  = "JWT"
  
  jwt_configuration {
    audience = [aws_cognito_user_pool_client.tf_up_client.id]
    issuer   = "https://cognito-idp.us-east-1.amazonaws.com/${aws_cognito_user_pool.tf_user_pool.id}"
  }
  
  depends_on = [
    aws_apigatewayv2_api.tf_api_gateway,
    aws_cognito_user_pool_client.tf_up_client
  ]
}


