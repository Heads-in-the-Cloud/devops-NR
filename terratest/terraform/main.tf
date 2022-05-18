terraform {
  required_version = ">= 0.12.26"
}

data "aws_availability_zones" "available" {
  state = "available"
}

provider "aws" {
  region = var.aws_region
}
