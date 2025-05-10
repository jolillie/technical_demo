output "vpc_id" {
  value = aws_vpc.main.id
}

output "public_subnet_id" {
  value = aws_subnet.public.id
}

output "private_subnet_id" {
  value = aws_subnet.private.id
}

output "instance_public_ip" {
  value = aws_instance.ubuntu_vm.public_ip
}

output "s3_bucket_name" {
  value = aws_s3_bucket.data_bucket.bucket
}

# output "cluster_name" {
#   value = aws_eks_cluster.main.name
# }

# output "cluster_endpoint" {
#   value = aws_eks_cluster.main.endpoint
# }

# output "cluster_ca_certificate" {
#   value = aws_eks_cluster.main.certificate_authority[0].data
# }