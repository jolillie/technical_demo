variable "vpc_id" {
  description = "VPC ID"
  type        = string
}

variable "subnet_id" {
  description = "Subnet ID"
  type        = string
}

variable "key_name" {
  description = "SSH key name to use for the EC2 instance"
  type        = string
}

variable "ubuntu_ami" {
  description = "AMI ID for Ubuntu"
  type        = string
}

variable "instance_type" {
  default     = "t3.micro"
  description = "Instance type for Ubuntu VM"
}

variable "bucket_name_prefix" {
  description = "Prefix for the S3 bucket name (a random suffix will be added)"
  type        = string
}

variable "root_volume_size" {
  description = "Root volume size in GB"
  type        = number
  default     = 20
}
