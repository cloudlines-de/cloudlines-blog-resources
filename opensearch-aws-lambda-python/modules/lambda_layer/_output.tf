output "lambda_layer_arn" {
  description = "ARN of the Lambda layer containing all packages"
  value       = aws_lambda_layer_version.third_party_python_packages.arn
}