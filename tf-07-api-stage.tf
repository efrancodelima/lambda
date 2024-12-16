resource "aws_apigatewayv2_stage" "tf_api_stage" {
  name           = "$default"
  api_id         = aws_apigatewayv2_api.tf_api_gateway.id
  
  auto_deploy    = true

  default_route_settings {
    detailed_metrics_enabled = false
    throttling_burst_limit   = 5   # 5 requisições imediatas
    throttling_rate_limit    = 5   # +5 requisição por segundo
  }

  depends_on = [
    aws_apigatewayv2_api.tf_api_gateway
  ]
}
