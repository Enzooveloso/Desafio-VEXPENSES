provider "aws" {
  region = "us-east-1"
}

module "vpc" {
  source = "./modules/vpc"
  environment = var.environment
}

module "security_group" {
  source    = "./modules/security-group"
  vpc_id    = module.vpc.vpc_id
}

module "ec2" {
  source            = "./modules/ec2"
  instance_type     = var.instance_type
  subnet_id         = module.vpc.subnet_id
  security_group_id = module.security_group.security_group_id
  ssh_public_key    = var.ssh_public_key
  environment       = var.environment
  availability_zone = var.availability_zone  
}


