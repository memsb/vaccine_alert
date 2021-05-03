variable "region" {
  default = "eu-west-2"
}

provider "aws" {
  profile = "default"
  region = var.region
}

data "aws_caller_identity" "current" {}