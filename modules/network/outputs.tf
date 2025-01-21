output "public_subnets_id" {
  value = [aws_subnet.public_a.id, aws_subnet.public_b.id]
}

output "private_subnets_id" {
  value = [aws_subnet.private_a.id, aws_subnet.private_b.id]
}

output "security_group_id" {
  value = aws_security_group.default.id
}

output "vpc_id" {
  value = aws_vpc.main.id
}

