resource "aws_subnet" "pub_subnet" {
  availability_zone = "us-west-2a"
  vpc_id            = aws_vpc.vpc.id
  cidr_block        = "10.0.0.0/24"
}

resource "aws_subnet" "pub_subnet_2" {
  availability_zone = "us-west-2b"
  vpc_id            = aws_vpc.vpc.id
  cidr_block        = "10.0.1.0/24"
}

# resource "aws_subnet" "priv_subnet" {
#   availability_zone = "us-west-2a"
#   vpc_id            = aws_vpc.vpc.id
#   cidr_block        = "10.0.2.0/24"
# }

# resource "aws_subnet" "priv_subnet_2" {
#   availability_zone = "us-west-2b"
#   vpc_id            = aws_vpc.vpc.id
#   cidr_block        = "10.0.3.0/24"
# }
