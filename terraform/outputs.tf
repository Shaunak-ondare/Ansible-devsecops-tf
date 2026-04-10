output "linux_public_ip" {
  value = module.compute.linux_public_ip
}

output "windows_public_ip" {
  value = module.compute.windows_public_ip
}

output "controller_public_ip" {
  value = module.compute.controller_public_ip
}

output "vpc_id" {
  value = module.vpc.vpc_id
}
