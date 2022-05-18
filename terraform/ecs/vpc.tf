provider "aws" {
  region = "us-west-2"
}

resource "aws_vpc" "vpc" {
  cidr_block           = "10.0.0.0/16"
  enable_dns_support   = true
  enable_dns_hostnames = true
  tags = {
    Name = "Terraform VPC"
  }
}

data "aws_secretsmanager_secret_version" "secrets" {
  secret_id = "utopia/mysql/db"
}

data "aws_ssm_parameter" "image_auth" {
  name = "utopia_image_auth"
}

data "aws_ssm_parameter" "image_booking" {
  name = "utopia_image_booking"
}

data "aws_ssm_parameter" "image_flight" {
  name = "utopia_image_flight"
}

data "aws_ssm_parameter" "image_orchestrator" {
  name = "utopia_image_orchestrator"
}

data "aws_ssm_parameter" "image_user" {
  name = "utopia_image_user"
}
