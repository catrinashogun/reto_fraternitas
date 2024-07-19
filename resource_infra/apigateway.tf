resource "aws_apigatewayv2_api" "fraternitas_api" {
  name          = "fraternitas_api"
  protocol_type = "HTTP"
}

resource "aws_apigatewayv2_authorizer" "fraternitas_cognito_authorizer" {
  api_id           = aws_apigatewayv2_api.fraternitas_api.id
  authorizer_type  = "JWT"
  identity_sources = ["$request.header.Authorization"]
  jwt_configuration {
    audience = [aws_cognito_user_pool_client.fraternitas_user_pool_client.id]
    issuer   = "https://cognito-idp.${var.region}.amazonaws.com/${aws_cognito_user_pool.fraternitas_user_pool.id}"
  }
  name = "fraternitas_cognito_authorizer"
}

resource "aws_apigatewayv2_integration" "fraternitas_lambda_integration" {
  api_id                = aws_apigatewayv2_api.fraternitas_api.id
  integration_type      = "AWS_PROXY"
  integration_uri       = aws_lambda_function.fraternitas_lambda.invoke_arn
  integration_method    = "POST"
  payload_format_version = "2.0"
}

resource "aws_apigatewayv2_route" "fraternitas_route" {
  api_id       = aws_apigatewayv2_api.fraternitas_api.id
  route_key    = "GET /"
  target       = "integrations/${aws_apigatewayv2_integration.fraternitas_lambda_integration.id}"
  authorizer_id = aws_apigatewayv2_authorizer.fraternitas_cognito_authorizer.id
  authorization_type = "JWT"
}

resource "aws_apigatewayv2_stage" "fraternitas_stage" {
  api_id      = aws_apigatewayv2_api.fraternitas_api.id
  name        = "$default"
  auto_deploy = true
}
