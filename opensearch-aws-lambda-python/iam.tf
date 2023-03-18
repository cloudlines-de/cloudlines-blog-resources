resource "aws_iam_role" "showcase_lambda_role" {
  name               = "${var.project}-lambda-role"
  assume_role_policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Action": "sts:AssumeRole",
      "Principal": {
        "Service": "lambda.amazonaws.com"
      },
      "Effect": "Allow"
    }
  ]
}
EOF
}

resource "aws_iam_policy" "showcase_lambda_policy" {
  name = "${var.project}-lambda-policy"
  policy = jsonencode({
    Version : "2012-10-17"
    Statement : [
      {
        Effect : "Allow",
        Action : [
          "logs:CreateLogStream",
          "logs:PutLogEvents"
        ],
        Resource : "arn:aws:logs:${data.aws_region.current.name}:${data.aws_caller_identity.current.account_id}:log-group:/aws/lambda/${local.lambda_function_name}"
      },
      {
        Effect: "Allow",
        Action: [
          "kms:GenerateDataKey",
          "kms:Decrypt"
        ],
        Resource: var.kms_key_arn
      },
      {
        Effect : "Allow",
        Action : [
          "ssm:GetParameter*",
        ],
        Resource : "arn:aws:ssm:${data.aws_region.current.name}:${data.aws_caller_identity.current.account_id}:parameter/opensearch-logging-*"
      }
    ]
  })
}

resource "aws_iam_role_policy_attachment" "lambda_policy_attachment" {
  role       = aws_iam_role.showcase_lambda_role.name
  policy_arn = aws_iam_policy.showcase_lambda_policy.arn
}