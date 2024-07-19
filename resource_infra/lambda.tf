data "aws_caller_identity" "current" {}

resource "aws_lambda_function" "fraternitas_lambda" {
  function_name = "fraternitas_lambda"
  role          = aws_iam_role.fraternitas_lambda_role.arn
  handler       = "dist/handler.handler"
  runtime       = "nodejs18.x"
  filename      = var.lambda_package_path
  source_code_hash = filebase64sha256(var.lambda_package_path)
  environment {
    variables = {
      NODE_ENV = "production"
    }
  }
}

resource "aws_iam_role" "fraternitas_lambda_role" {
  name = "fraternitas_lambda_role"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = "sts:AssumeRole"
        Effect = "Allow"
        Principal = {
          Service = "lambda.amazonaws.com"
        }
      }
    ]
  })
}

resource "aws_iam_role_policy_attachment" "lambda_basic_execution" {
  role       = aws_iam_role.fraternitas_lambda_role.name
  policy_arn = "arn:aws:iam::aws:policy/service-role/AWSLambdaBasicExecutionRole"
}

resource "aws_lambda_permission" "apigateway_invocation" {
  statement_id  = "AllowExecutionFromAPIGateway"
  action        = "lambda:InvokeFunction"
  function_name = aws_lambda_function.fraternitas_lambda.function_name
  principal     = "apigateway.amazonaws.com"
  source_arn    = "arn:aws:execute-api:${var.region}:${data.aws_caller_identity.current.account_id}:${aws_apigatewayv2_api.fraternitas_api.id}/*/*/"
}
