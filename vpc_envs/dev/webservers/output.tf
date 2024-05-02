# For Webservers
output "webserver_ids" {
  value = module.vms-dev.webservers_ids
}

output "webserver_private_ips" {
  value = module.vms-dev.webserver_private_ips
}


output "webserver_public_ips" {
  value = module.vms-dev.webserver_public_ips
}


output "instance_availability_zones" {
    value = module.vms-dev.webserver_availability_zones
}

# For private VMs
output "private_vm_ids" {
  value = module.vms-dev.private_vm_ids
}

output "private_vm_private_ips" {
  value = module.vms-dev.private_vm_private_ips
}


output "private_vm_availability_zones" {
    value = module.vms-dev.private_vm_availability_zones
}

