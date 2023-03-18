locals {
  lambda_function_name = "${var.project}-lambda"
}

resource "aws_lambda_function" "showcase_lambda" {
  function_name    = local.lambda_function_name
  description      = "OpenSearch logging showcase"
  filename         = data.archive_file.showcase_lambda.output_path
  source_code_hash = data.archive_file.showcase_lambda.output_base64sha256
  runtime          = "python3.8"
  handler          = "main.lambda_handler"
  timeout          = 30
  memory_size      = 128
  role             = aws_iam_role.showcase_lambda_role.arn

  layers = [
    module.lambda_layer.lambda_layer_arn
  ]

  environment {
    variables = {
      LOG_LEVEL = "INFO"
    }
  }
}

resource "aws_cloudwatch_log_group" "lambda_logs" {
  name              = "/aws/lambda/${local.lambda_function_name}"
  retention_in_days = 14
  depends_on        = [aws_lambda_function.showcase_lambda]
}