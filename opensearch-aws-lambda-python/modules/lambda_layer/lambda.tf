resource "aws_lambda_layer_version" "third_party_python_packages" {
  filename                 = "${path.module}/packages.zip"
  layer_name               = "${var.name}-third-party-python-packages${var.name_suffix}"
  description              = "Additional third party python packages Lambda functions"
  compatible_architectures = ["x86_64"]
  compatible_runtimes      = ["python3.8"]

  source_code_hash = filebase64sha256("${path.module}/packages.zip")
}