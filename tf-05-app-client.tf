resource "aws_cognito_user_pool_client" "tf_up_client" {
  name                   = "lanchonete-up-client"
  user_pool_id           = aws_cognito_user_pool.tf_user_pool.id
  generate_secret        = true
  refresh_token_validity = 5
  access_token_validity  = 60
  id_token_validity      = 60

  token_validity_units {
    access_token  = "minutes"
    id_token      = "minutes"
    refresh_token = "days"
  }

  read_attributes = [
    "email",
    "email_verified",
    "gender",
    "name",
    "nickname",
    "phone_number",
    "phone_number_verified",
    "preferred_username",
    "profile",
    "updated_at",
    "zoneinfo"
  ]

  write_attributes = [
    "email",
    "gender",
    "name",
    "nickname",
    "phone_number",
    "preferred_username",
    "profile",
    "updated_at",
    "zoneinfo"
  ]

  supported_identity_providers = ["COGNITO"]

  callback_urls = ["https://example.com"]

  allowed_oauth_flows = [
    "code",
    "implicit"
  ]

  allowed_oauth_scopes = [
    "email",
    "openid"
  ]

  allowed_oauth_flows_user_pool_client = true
  prevent_user_existence_errors        = "ENABLED"
  enable_token_revocation              = true
  auth_session_validity                = 3

  depends_on = [
    aws_cognito_user_pool.tf_user_pool
  ]
}
