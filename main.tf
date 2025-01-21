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
  public_subnets_id       = module.network.public_subnets_id
  private_subnet_id       = module.network.private_subnets_id
  security_group_id       = module.network.security_group_id
  vpc_id                  = module.network.vpc_id
  s3_image_url            = module.storage.s3_image_url
}

module "storage" {
  source = "./modules/storage"

  Owner = var.Owner
}

output "instances_info" {
  description = "Information about public instances"
  value       = module.instances.instances_info
}

output "alb_dns_name" {
  description = "DNS name of the Load Balancer"
  value       = module.instances.alb_dns_name
}

output "s3_image_url" {
  description = "Public URL of the image stored in S3"
  value       = module.storage.s3_image_url
}
