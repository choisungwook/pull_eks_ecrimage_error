output "vpc_id" {
  description = "vpc_id"
  value       = aws_vpc.main.id
}

output "private_subnets_ids" {
  description = "private subnets ids"
  value       = [for private_subnet in aws_subnet.private : private_subnet.id]
}

output "private_route_table_id" {
  description = "private route table ids"
  value       = aws_route_table.private.id
}
