resource "aws_cognito_user_pool" "fraternitas_user_pool" {
  name = "fraternitas_user_pool"
}

resource "aws_cognito_user_pool_client" "fraternitas_user_pool_client" {
  name                           = "fraternitas_user_pool_client"
  user_pool_id                   = aws_cognito_user_pool.fraternitas_user_pool.id
  allowed_oauth_flows_user_pool_client = true
  allowed_oauth_flows            = ["code"]
  allowed_oauth_scopes           = ["email", "openid", "profile"]
  callback_urls                  = ["https://example.com/callback"]
}

resource "aws_cognito_user_pool_domain" "fraternitas_user_pool_domain" {
  domain       = "fraternitas-unique-domain"
  user_pool_id = aws_cognito_user_pool.fraternitas_user_pool.id
}
