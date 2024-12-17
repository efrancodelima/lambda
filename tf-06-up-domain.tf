resource "aws_cognito_user_pool_domain" "tf_up_domain" {
  domain       = "us-east-1-up-domain"
  user_pool_id = aws_cognito_user_pool.tf_user_pool.id

  depends_on = [
    aws_cognito_user_pool.tf_user_pool
  ]
}
