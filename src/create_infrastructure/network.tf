resource "yandex_vpc_network" "network" {
  name        = var.network_name
  description = "Final work network name"
}

resource "yandex_vpc_subnet" "nat_subnet" {
  name           = var.nat_subnet_params.name
  zone           = var.nat_subnet_params.zone
  network_id     = yandex_vpc_network.network.id
  v4_cidr_blocks = var.nat_subnet_params.cidr
}


module "nat_vm" {
  source                 = "./local_module_vm"
  env_name               = var.nat_vm_params.name
  zone_name              = yandex_vpc_subnet.nat_subnet.zone
  subnet_id              = yandex_vpc_subnet.nat_subnet.id
  image_family           = var.nat_image_family
  instance_cores         = var.nat_vm_params.cores
  instance_memory        = var.nat_vm_params.memory
  instance_core_fraction = var.nat_vm_params.core_fraction
  disk_size              = var.nat_vm_params.disk_size
  platform_id            = var.nat_vm_params.platform_id
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

resource "yandex_vpc_route_table" "nat_route_table" {
  name        = var.route_table_name
  network_id  = yandex_vpc_network.network.id
  description = "Route table for final work"

  static_route {
    destination_prefix = var.route_table_destination_prefix
    next_hop_address   = module.nat_vm.vm.0.network_interface.0.ip_address
  }
}

resource "yandex_vpc_security_group" "nat_security_group" {
  name       = var.security_group_name
  network_id = yandex_vpc_network.network.id

  egress {
    protocol       = "ANY"
    description    = "any"
    v4_cidr_blocks = ["0.0.0.0/0"]
  }
  
  ingress {
    protocol       = "ANY"
    description    = "any"
    v4_cidr_blocks = ["0.0.0.0/0"]
  }
}

resource "yandex_vpc_subnet" "subnets" {
  for_each = {for env in var.subnet_params : env.name => env}
  name           = each.value.name
  zone           = each.value.zone
  network_id     = yandex_vpc_network.network.id
  v4_cidr_blocks = each.value.cidr
  route_table_id = yandex_vpc_route_table.nat_route_table.id
}

