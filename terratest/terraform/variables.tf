variable "main_vpc_cidr" {
  description = "The CIDR of the main VPC"
  type        = string
}

variable "public1_subnet_cidr" {
  description = "The CIDR of public subnet"
  type        = string
}

variable "public2_subnet_cidr" {
  description = "The CIDR of public subnet"
  type        = string
}

variable "private1_subnet_cidr" {
  description = "The CIDR of the private subnet"
  type        = string
}

variable "private2_subnet_cidr" {
  description = "The CIDR of the private subnet"
  type        = string
}

variable "aws_region" {
  description = "The AWS region to deploy into"
  type        = string
  default     = "us-east-1"
}

variable "tag_name" {
  description = "A name used to tag the resource"
  type        = string
  default     = "utopia-network-dev"
}
