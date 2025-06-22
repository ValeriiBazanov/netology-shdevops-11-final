resource "yandex_lb_target_group" "k8s_load_balancer" {
  name = var.lb_target_group_params.name
  
  dynamic "target" {
    for_each = { for env in module.worker_nodes.final-work-subnet-a.vm : env.id => env }
    
    content {
      subnet_id  = target.value.network_interface[0].subnet_id
      address    = target.value.network_interface[0].ip_address
    }
  }

  dynamic "target" {
    for_each = { for env in module.worker_nodes.final-work-subnet-b.vm : env.id => env }
    
    content {
      subnet_id  = target.value.network_interface[0].subnet_id
      address    = target.value.network_interface[0].ip_address
    }
  }

  dynamic "target" {
    for_each = { for env in module.worker_nodes.final-work-subnet-d.vm : env.id => env }
    
    content {
      subnet_id  = target.value.network_interface[0].subnet_id
      address    = target.value.network_interface[0].ip_address
    }
  }
}

resource "yandex_lb_network_load_balancer" "k8s-load-balancer" {
  name = var.lb_name

  dynamic "listener" {
    for_each = { for env in var.lb_listener_params : env.name => env }

    content {
      name = listener.value.name
      port = listener.value.port
      target_port = listener.value.target_port

      external_address_spec {
        ip_version = listener.value.ip_version
      }
    }
  }

  attached_target_group {
    target_group_id = yandex_lb_target_group.k8s_load_balancer.id
    healthcheck {
      name = var.lb_target_group_params.healthcheck_name
      tcp_options {
        port = var.lb_target_group_params.healthcheck_port
      }
    }
  }
}