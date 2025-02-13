resource "aws_ebs_volume" "accounts" {
  availability_zone = var.availability_zone
  size              = 1000
  type              = "gp3"
  iops              = 7000
  throughput        = 700

  tags = {
    Name = "accounts-volume"
  }
}

resource "aws_ebs_volume" "data" {
  availability_zone = var.availability_zone
  size              = 2000
  type              = "gp3"
  iops              = 9000
  throughput        = 700

  tags = {
    Name = "data-volume"
  }
}

resource "aws_volume_attachment" "accounts_att" {
  device_name = "/dev/sdf"
  volume_id   = aws_ebs_volume.accounts.id
  instance_id = var.instance_id
}

resource "aws_volume_attachment" "data_att" {
  device_name = "/dev/sdg"
  volume_id   = aws_ebs_volume.data.id
  instance_id = var.instance_id
}
