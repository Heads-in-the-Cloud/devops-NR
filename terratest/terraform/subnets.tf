resource "aws_subnet" "public1" {
  vpc_id                  = aws_vpc.main.id
  cidr_block              = var.public1_subnet_cidr
  map_public_ip_on_launch = true

  tags = {
    Name = var.tag_name,
    Type = "public"
  }

  availability_zone = data.aws_availability_zones.available.names[0]
}

resource "aws_subnet" "public2" {
  vpc_id                  = aws_vpc.main.id
  cidr_block              = var.public2_subnet_cidr
  map_public_ip_on_launch = true

  tags = {
    Name = var.tag_name,
    Type = "public"
  }

  availability_zone = data.aws_availability_zones.available.names[1]
}

resource "aws_subnet" "private1" {
  vpc_id                  = aws_vpc.main.id
  cidr_block              = var.private1_subnet_cidr
  map_public_ip_on_launch = false

  tags = {
    Name = var.tag_name,
    Type = "private"
  }

  availability_zone = data.aws_availability_zones.available.names[0]
}

resource "aws_subnet" "private2" {
  vpc_id                  = aws_vpc.main.id
  cidr_block              = var.private2_subnet_cidr
  map_public_ip_on_launch = false

  tags = {
    Name = var.tag_name,
    Type = "private"
  }

  availability_zone = data.aws_availability_zones.available.names[1]
}
