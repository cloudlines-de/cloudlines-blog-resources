terraform {
  required_version = ">= 1.0.0"

  # I strongly recommend using a remote state
  #  backend "s3" {
  #    bucket = "your-s3-bucket"
  #    key    = "terraform.tfstate"
  #    region = "eu-central-1"
  #  }

  required_providers {
    aws = {
      version = "> 4.0.0"
    }
  }
}

provider "aws" {
  region = var.region

  default_tags {
    tags = {
      Provisioner = "terraform"
      Project     = var.project
    }
  }
}