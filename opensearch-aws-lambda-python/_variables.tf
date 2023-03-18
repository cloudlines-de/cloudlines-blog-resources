variable "region" {
  type        = string
  description = "AWS Region"
  default     = "eu-central-1"
}

variable "project" {
  type        = string
  description = "Name of the project, used for naming and tagging resources"
  default     = "opensearch-showcase"
}

variable "kms_key_arn" {
  type        = string
  description = "ARN of the KMS key that the SSM parameters have been encrypted with"
}