resource "aws_cognito_user_pool" "tf_user_pool" {
  name                     = "lanchonete-user-pool"
  deletion_protection      = "INACTIVE"

  password_policy {
    minimum_length                   = 8
    require_uppercase                = true
    require_lowercase                = true
    require_numbers                  = true
    require_symbols                  = true
    temporary_password_validity_days = 7
  }

  lambda_config {
    pre_authentication = data.aws_lambda_function.tf_lambda.arn
  }

  auto_verified_attributes = ["email"]
  alias_attributes         = ["email"]

  verification_message_template {
    default_email_option = "CONFIRM_WITH_CODE"
  }

  mfa_configuration = "OFF"

  email_configuration {
    email_sending_account = "COGNITO_DEFAULT"
  }

  admin_create_user_config {
    allow_admin_create_user_only = false
  }

  username_configuration {
    case_sensitive = false
  }

  schema {
    name                    = "name"
    attribute_data_type     = "String"
    developer_only_attribute = false
    mutable                = true
    required               = true
    string_attribute_constraints {
      min_length = 0
      max_length = 2048
    }
  }
  
  schema {
    name                    = "email"
    attribute_data_type     = "String"
    developer_only_attribute = false
    mutable                = true
    required               = true
    string_attribute_constraints {
      min_length = 0
      max_length = 2048
    }
  }

  schema {
    name                    = "email_verified"
    attribute_data_type     = "Boolean"
    developer_only_attribute = false
    mutable                = true
    required               = false
  }

  schema {
    name                    = "sub"
    attribute_data_type     = "String"
    developer_only_attribute = false
    mutable                = false
    required               = true
    string_attribute_constraints {
      min_length = 1
      max_length = 2048
    }
  }

  schema {
    name                     = "CPF"
    attribute_data_type      = "Number"
    developer_only_attribute = false
    mutable                  = true
    required                 = false
    number_attribute_constraints {
      min_value = 1
      max_value = 99999999999
    }
  }
}
