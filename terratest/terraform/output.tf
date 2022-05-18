output "main_vpc_id" {
  value       = aws_vpc.main.id
  description = "The main VPC id"
}

output "public1_subnet_id" {
  value       = aws_subnet.public1.id
  description = "The public subnet id"
}

output "public2_subnet_id" {
  value       = aws_subnet.public2.id
  description = "The public subnet id"
}

output "private1_subnet_id" {
  value       = aws_subnet.private1.id
  description = "The private subnet id"
}

output "private2_subnet_id" {
  value       = aws_subnet.private2.id
  description = "The private subnet id"
}
