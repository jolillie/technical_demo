output "vpc_id" {
  value = aws_vpc.main.id
}

output "public_subnet_id" {
  value = aws_subnet.public.id
}

output "private_a_subnet_id" {
  value = aws_subnet.private-a.id
}

output "private_b_subnet_id" {
  value = aws_subnet.private-b.id
}