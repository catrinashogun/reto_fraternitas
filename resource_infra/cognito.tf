resource "aws_cognito_user_pool" "fraternitas_user_pool" {
  name = "fraternitas_user_pool"

  account_recovery_setting {
    recovery_mechanism {
      name     = "verified_email"
      priority = 1
    }
    recovery_mechanism {
      name     = "verified_phone_number"
      priority = 2
    }
  }
}

resource "aws_cognito_user_pool_domain" "fraternitas_user_pool_domain" {
  domain       = "fraternitas-unique-domain"  # Replace this with your unique domain name
  user_pool_id = aws_cognito_user_pool.fraternitas_user_pool.id
}

resource "aws_cognito_resource_server" "fraternitas_resource_server" {
  identifier   = "fraternitas"
  name         = "fraternitas_resource_server"
  user_pool_id = aws_cognito_user_pool.fraternitas_user_pool.id

  scope {
    scope_name        = "sec"
    scope_description = "Custom scope for client credentials fraternitas"
  }
}

resource "aws_cognito_user_pool_client" "fraternitas_user_pool_client" {
  name                           = "fraternitas_user_pool_client"
  user_pool_id                   = aws_cognito_user_pool.fraternitas_user_pool.id
  generate_secret                = true
  allowed_oauth_flows_user_pool_client = true
  allowed_oauth_flows            = ["client_credentials"]
  allowed_oauth_scopes           = ["fraternitas/sec"]
  callback_urls                  = ["https://example.com/callback"]
}