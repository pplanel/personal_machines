output "accounts_volume_id" {
  value = aws_ebs_volume.accounts.id
}

output "data_volume_id" {
  value = aws_ebs_volume.data.id
}
