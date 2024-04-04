output "aws_instances" {
  value = aws_instance.server01.public_ip
}

output "key_pair_name" {
  value = aws_key_pair.my_keypair.key_name
}
