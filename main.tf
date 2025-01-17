# data "aws_vpc" "develop" {
#   default = true
# }

# data "aws_availability_zones" "av_zone" {
# }

module "network" {
  source = "./modules/network"
}

module "instances" {
  source = "./modules/instances"

  vm_public_instance_type = var.vm_public_instance_type
  key_name                = var.key_name
  Owner                   = var.Owner
  Project                 = var.Project
  Platform                = var.Platform

  public_subnet_id  = module.network.public_subnet_id
  private_subnet_id = module.network.private_subnet_id
  security_group_id = module.network.security_group_id
}

output "instances_info" {
  description = "Information about public instances"
  value       = module.instances.instances_info
}
