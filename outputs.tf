output "public_ip" {
  value = aws_instance.server01.public_ip
}

output "instance_id" {
  value = aws_instance.server01.id
}

output "key_pair_name" {
  value = data.aws_key_pair.pplanel.key_name
}
