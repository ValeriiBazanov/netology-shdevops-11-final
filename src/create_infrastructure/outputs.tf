output "network_id" {
  value = yandex_vpc_network.network.id
}

output "subnet_id" {
  value = {
    for idx, subnet in yandex_vpc_subnet.subnets :
    subnet.zone => subnet.id
  }
}
