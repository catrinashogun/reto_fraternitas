resource "aws_iam_role" "fraternitas_lambda_role" {
  name = "fraternitas_lambda_role"
  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = "sts:AssumeRole"
        Effect = "Allow"
        Sid    = ""
        Principal = {
          Service = "lambda.amazonaws.com"
        }
      },
    ]
  })
}

resource "aws_iam_role_policy_attachment" "fraternitas_lambda_policy" {
  role       = aws_iam_role.fraternitas_lambda_role.name
  policy_arn = "arn:aws:iam::aws:policy/AWSLambdaExecute"
}

resource "aws_lambda_function" "fraternitas_lambda" {
  filename         = var.lambda_package_path
  function_name    = "fraternitas_lambda"
  role             = aws_iam_role.fraternitas_lambda_role.arn
  handler          = "dist/handler.handler"
  runtime          = "nodejs18.x"
  source_code_hash = filebase64sha256(var.lambda_package_path)
}
