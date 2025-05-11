variable "eks_cluster_name" {
  description = "Name of the EKS cluster"
  type        = string
}

variable "vpc_id" {
  description = "VPC ID"
  type        = string
}

variable "private_a_subnet_id" {
  description = "Private Subnet A ID"
  type        = string
}

variable "private_b_subnet_id" {
  description = "Private Subnet B ID"
  type        = string
}