data "aws_caller_identity" "current" {}

data "aws_region" "current" {}

data "archive_file" "showcase_lambda" {
  type        = "zip"
  output_path = "${path.module}/lambda_src/showcase.zip"

  source {
    content  = file("${path.module}/lambda_src/showcase/main.py")
    filename = "main.py"
  }

  source {
    content  = file("${path.module}/lambda_src/showcase/utils.py")
    filename = "utils.py"
  }
}