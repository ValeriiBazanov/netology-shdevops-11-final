module "master_nodes" {
  for_each               = {for env in yandex_vpc_subnet.subnets : env.name => env}
  
  source                 = "./local_module_vm"
  env_name               = var.master_nodes_params.name
  zone_name              = each.value.zone
  subnet_id              = each.value.id
  instance_count         = var.master_nodes_params.count
  image_family           = var.image_family
  instance_cores         = var.master_nodes_params.cores
  instance_memory        = var.master_nodes_params.memory
  instance_core_fraction = var.master_nodes_params.core_fraction
  disk_size              = var.master_nodes_params.disk_size
  platform_id            = var.master_nodes_params.platform_id
  need_nat               = false 
  security_group_ids     = [ yandex_vpc_security_group.nat_security_group.id ]

  labels = { 
    owner= "v.bazanov",
    project = "finalwork"
  }

  metadata = {
    user-data          = data.template_file.cloudinit.rendered
    serial-port-enable = 1
  }

}

module "worker_nodes" {
  for_each               = {for env in yandex_vpc_subnet.subnets : env.name => env}
  
  source                 = "./local_module_vm"
  env_name               = var.worker_nodes_params.name
  zone_name              = each.value.zone
  subnet_id              = each.value.id
  instance_count         = var.worker_nodes_params.count
  image_family           = var.image_family
  instance_cores         = var.worker_nodes_params.cores
  instance_memory        = var.worker_nodes_params.memory
  instance_core_fraction = var.worker_nodes_params.core_fraction
  disk_size              = var.worker_nodes_params.disk_size
  platform_id            = var.worker_nodes_params.platform_id
  need_nat               = false 
  security_group_ids     = [ yandex_vpc_security_group.nat_security_group.id ]

  labels = { 
    owner= "v.bazanov",
    project = "finalwork"
  }

  metadata = {
    user-data          = data.template_file.cloudinit.rendered
    serial-port-enable = 1
  }

}

module "admin_vm" {
  source                 = "./local_module_vm"
  env_name               = var.admin_vm_params.name
  zone_name              = yandex_vpc_subnet.nat_subnet.zone
  subnet_id              = yandex_vpc_subnet.nat_subnet.id
  image_family           = var.image_family
  instance_cores         = var.admin_vm_params.cores
  instance_memory        = var.admin_vm_params.memory
  instance_core_fraction = var.admin_vm_params.core_fraction
  disk_size              = var.admin_vm_params.disk_size
  platform_id            = var.admin_vm_params.platform_id
  need_nat               = true 
  security_group_ids     = [ yandex_vpc_security_group.nat_security_group.id ]

  labels = { 
    owner= "v.bazanov",
    project = "finalwork"
  }

  metadata = {
    user-data          = data.template_file.cloudinit.rendered
    serial-port-enable = 1
  }

}