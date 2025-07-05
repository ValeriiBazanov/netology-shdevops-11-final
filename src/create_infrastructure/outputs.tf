output "network_id" {
  value = yandex_vpc_network.network.id
}

output "subnet_id" {
  value = {
    for idx, subnet in yandex_vpc_subnet.subnets :
    subnet.zone => subnet.id
  }
}

output "nat_ip" {
  value = module.nat_vm.vm.0.network_interface.0.nat_ip_address
}

output "admin_ip" {
  value = module.admin_vm.vm.0.network_interface.0.nat_ip_address
}

output "load_balancer_listener" {
  value = [
    for listener in yandex_lb_network_load_balancer.k8s-load-balancer.listener : {
      name    = listener.name
      port    = listener.port
      address = [for addr in listener.external_address_spec : addr.address][0]
    }
  ]
}
