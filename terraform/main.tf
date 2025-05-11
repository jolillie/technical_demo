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
  source = "./base"
}

# module "ubuntu_vm" {
#   source  = "./ubuntu_vm"
#   vpc_id  = module.base.vpc_id
#   subnet_id = module.base.public_subnet_id
# }

# module "k8s_cluster" {
#   source  = "./k8s_cluster"
#   vpc_id  = module.base.vpc_id
#   public_subnet_id  = module.base.public_subnet_id
#   private_subnet_id = module.base.private_subnet_id
# }