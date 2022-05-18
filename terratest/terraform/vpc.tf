resource "aws_vpc" "main" {
  cidr_block = var.main_vpc_cidr

  tags = {
    Name = var.tag_name
  }
}
