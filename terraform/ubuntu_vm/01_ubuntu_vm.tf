# # === IAM Role and Policy for EC2 to access S3 ===
# resource "aws_iam_role" "ec2_role" {
#   name = "ubuntu-vm-role"
#   assume_role_policy = jsonencode({
#     Version = "2012-10-17"
#     Statement = [{
#       Action = "sts:AssumeRole"
#       Effect = "Allow"
#       Principal = {
#         Service = "ec2.amazonaws.com"
#       }
#     }]
#   })
# }

# resource "aws_iam_role_policy_attachment" "over_permissive_access" {
#   role       = aws_iam_role.ec2_role.name
#   policy_arn = "arn:aws:iam::aws:policy/AdministratorAccess"
# }

# resource "aws_iam_instance_profile" "ec2_instance_profile" {
#   name = "ubuntu-vm-profile"
#   role = aws_iam_role.ec2_role.name
# }

# # === Security Group for EC2 ===
# resource "aws_security_group" "vm_sg" {
#   name        = "ubuntu-vm-sg"
#   description = "Allow SSH"
#   vpc_id      = aws_vpc.main.id

#   ingress {
#     from_port   = 22
#     to_port     = 22
#     protocol    = "tcp"
#     cidr_blocks = ["0.0.0.0/0"]
#   }

#   egress {
#     from_port   = 0
#     to_port     = 0
#     protocol    = "-1"
#     cidr_blocks = ["0.0.0.0/0"]
#   }
# }

# # === EC2 Instance ===
# resource "aws_instance" "ubuntu_vm" {
#   ami                         = var.ubuntu_ami
#   instance_type               = var.instance_type
#   subnet_id                   = aws_subnet.public.id
#   vpc_security_group_ids      = [aws_security_group.vm_sg.id]
#   associate_public_ip_address = true
#   iam_instance_profile        = aws_iam_instance_profile.ec2_instance_profile.name
#   key_name                    = var.key_name

#   tags = {
#     Name = "ubuntu-vm"
#   }

#   root_block_device {
#     volume_size = var.root_volume_size
#     volume_type = "gp2"
#   }
# }