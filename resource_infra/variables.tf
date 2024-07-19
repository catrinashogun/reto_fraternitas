variable "region" {
  description = "The AWS region to deploy resources"
  default     = "us-east-1"
}

variable "lambda_package_path" {
  description = "Path to the Lambda package"
  type        = string
  default     = "../lambda_nozip/.serverless/fraternitas.zip"
}