resource "yandex_vpc_network" "network" {
  name        = var.network_name
  description = "Final work network name"
}

resource "yandex_vpc_gateway" "nat_gateway" {
  name        = var.nat_gateway_name
  description = "NAT gateway for final work"
  
  shared_egress_gateway {}
}

resource "yandex_vpc_route_table" "route_table" {
  name        = var.route_table_name
  network_id  = yandex_vpc_network.network.id
  description = "Route table for final work"

  static_route {
    destination_prefix = var.route_table_destination_prefix
    gateway_id         = yandex_vpc_gateway.nat_gateway.id
  }
}

resource "yandex_vpc_subnet" "subnets" {
  for_each = {for env in var.subnet_params : env.name => env}
  name           = each.value.name
  zone           = each.value.zone
  network_id     = yandex_vpc_network.network.id
  v4_cidr_blocks = each.value.cidr
  route_table_id = yandex_vpc_route_table.route_table.id
}
