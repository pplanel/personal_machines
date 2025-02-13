output "instance_id" {
  value = aws_instance.server01.id
}

output "public_ip" {
  value = aws_instance.server01.public_ip
}

output "public_dns" {
  value = aws_instance.server01.public_dns
}

output "availability_zone" {
  value = aws_instance.server01.availability_zone
}
