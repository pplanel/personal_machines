output "public_ip" {
  value = module.compute.public_ip
}

output "instance_id" {
  value = module.compute.instance_id
}

output "key_pair_name" {
  value = aws_key_pair.new_kp.key_name
}
