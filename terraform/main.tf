terraform {
  cloud {
    organization = "jtl-tfc-org"
    workspaces {
      name = "wiz-tech-presentation"
    }
  }
}

provider "aws" {
  region = "us-east-1"
}

module "base" {
  source           = "./base"
  eks_cluster_name = var.eks_cluster_name
}

module "ubuntu_vm" {
  source             = "./ubuntu_vm"
  vpc_id             = module.base.vpc_id
  subnet_id          = module.base.private_a_subnet_id
  key_name           = var.key_name
  ubuntu_ami         = var.ubuntu_ami
  instance_type      = var.instance_type
  root_volume_size   = var.root_volume_size
  bucket_name_prefix = var.bucket_name_prefix
}

module "k8s_cluster" {
  source              = "./k8s_cluster"
  eks_cluster_name    = var.eks_cluster_name
  vpc_id              = module.base.vpc_id
  private_a_subnet_id = module.base.private_a_subnet_id
  private_b_subnet_id = module.base.private_b_subnet_id
}