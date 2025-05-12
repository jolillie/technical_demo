resource "aws_iam_role" "eks_cluster_role" {
  name = "eksClusterRole"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [{
      Action = "sts:AssumeRole"
      Principal = {
        Service = "eks.amazonaws.com"
      }
      Effect = "Allow"
      Sid    = ""
    }]
  })
}

resource "aws_iam_role_policy_attachment" "eks_cluster_AmazonEKSClusterPolicy" {
  policy_arn = "arn:aws:iam::aws:policy/AmazonEKSClusterPolicy"
  role       = aws_iam_role.eks_cluster_role.name
}


resource "aws_eks_cluster" "main" {
  name     = var.eks_cluster_name
  role_arn = aws_iam_role.eks_cluster_role.arn

  vpc_config {
    subnet_ids = [var.private_a_subnet_id, var.private_b_subnet_id]
    endpoint_public_access = true
  }

  enabled_cluster_log_types = ["api", "audit", "authenticator", "controllerManager", "scheduler"]

  depends_on = [aws_iam_role_policy_attachment.eks_cluster_AmazonEKSClusterPolicy]
}

# Security group allowing access to MongoDB EC2
resource "aws_security_group" "eks_mongo_access" {
  name   = "eks-mongo-access"
  vpc_id = var.vpc_id

  ingress {
    from_port   = 27017
    to_port     = 27017
    protocol    = "tcp"
    cidr_blocks = ["10.0.0.0/16"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

resource "aws_iam_role" "fargate_pod_execution_role" {
  name = "fargatePodExecutionRole"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [{
      Effect = "Allow"
      Principal = { Service = "eks-fargate-pods.amazonaws.com" }
      Action    = "sts:AssumeRole"
    }]
  })
}

resource "aws_iam_role_policy_attachment" "fargate_pod_policy" {
  role       = aws_iam_role.fargate_pod_execution_role.name
  policy_arn = "arn:aws:iam::aws:policy/AmazonEKSFargatePodExecutionRolePolicy"
}

resource "aws_eks_fargate_profile" "default" {
  cluster_name           = aws_eks_cluster.main.name
  fargate_profile_name   = "default"
  pod_execution_role_arn = aws_iam_role.fargate_pod_execution_role.arn
  subnet_ids             = [var.private_a_subnet_id, var.private_b_subnet_id]

  selector {
    namespace = "default"
  }

  depends_on = [
    aws_eks_cluster.main,
    aws_iam_role_policy_attachment.fargate_pod_policy
  ]
}

resource "aws_eks_fargate_profile" "kube_system" {
  cluster_name           = aws_eks_cluster.main.name
  fargate_profile_name   = "kube-system"
  pod_execution_role_arn = aws_iam_role.fargate_pod_execution_role.arn
  subnet_ids             = [var.private_a_subnet_id, var.private_b_subnet_id]  # Adjust to your actual variable

  selector {
    namespace = "kube-system"
    labels = {
      "k8s-app" = "kube-dns"
    }
  }

  tags = {
    Name = "kube-system-fargate-profile"
  }
}

resource "aws_eks_fargate_profile" "argocd" {
  cluster_name           = aws_eks_cluster.main.name
  fargate_profile_name   = "argocd"
  pod_execution_role_arn = aws_iam_role.fargate_pod_execution_role.arn
  subnet_ids             = [var.private_a_subnet_id, var.private_b_subnet_id]  # Adjust to your actual variable

  selector {
    namespace = "argocd"
    labels = {
      "k8s-app" = "argocd"
    }
  }

  tags = {
    Name = "argocd-fargate-profile"
  }
}