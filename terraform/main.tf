module "vpc" {
  source       = "./modules/vpc"
  project_name = var.project_name
}

module "compute" {
  source           = "./modules/compute"
  project_name     = var.project_name
  vpc_id           = module.vpc.vpc_id
  public_subnet_id = module.vpc.public_subnet_id
  public_key       = var.ssh_public_key
}
