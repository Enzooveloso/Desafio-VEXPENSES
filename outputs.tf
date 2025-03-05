output "vpc_id" {
  value = module.vpc.vpc_id
}

output "subnet_id" {
  value = module.vpc.subnet_id
}

output "security_group_id" {
  value = module.security_group.security_group_id
}

output "ec2_public_ip" {
  value = module.ec2.public_ip
}
