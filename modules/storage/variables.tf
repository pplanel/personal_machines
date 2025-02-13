variable "availability_zone" {
  type        = string
  description = "The availability zone where volumes will be created"
}

variable "instance_id" {
  type        = string
  description = "The ID of the EC2 instance to attach volumes to"
}
