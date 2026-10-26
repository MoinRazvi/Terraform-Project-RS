output "vpc_id" {
  value = aws_vpc.main.id
}

output "subnet_a_id" {
  value = aws_subnet.subnet_a.id
}

output "subnet_b_id" {
  value = aws_subnet.subnet_b.id
}

output "server_a_id" {
  value = aws_instance.server_a.id
}

output "server_b_id" {
  value = aws_instance.server_b.id
}

output "server_a_private_ip" {
  value = aws_instance.server_a.private_ip
}

output "server_b_private_ip" {
  value = aws_instance.server_b.private_ip
}
