variable "token" {
  type        = string
  description = "OAuth-token; https://cloud.yandex.ru/docs/iam/concepts/authorization/oauth-token"
}

variable "cloud_id" {
  type        = string
  description = "https://cloud.yandex.ru/docs/resource-manager/operations/cloud/get-id"
}

variable "folder_id" {
  type        = string
  description = "https://cloud.yandex.ru/docs/resource-manager/operations/folder/get-id"
}

variable "public_key" {
  type        = string
  description = "Public key"
}

variable "default_zone" {
  type        = string
  default     = "ru-central1-a"
  description = "https://cloud.yandex.ru/docs/overview/concepts/geo-scope"
}

variable "network_name" {
  type        = string
  default     = "finalwork"
  description = "Network name"
}

variable "nat_subnet_params" {
    type = object({ 
        name = string, 
        zone = string, 
        cidr = list(string)
    })

    default = {
        name = "final-work-subnet-nat",
        zone = "ru-central1-a",
        cidr = ["192.168.10.0/24"]
    }
    
    description = "NAT subnet params"
}

variable "route_table_name" {
  type        = string
  default     = "finalwork-route-table"
  description = "Route table name"
}

variable "route_table_destination_prefix" {
  type        = string
  default     = "0.0.0.0/0"
  description = "Route table destination prefix"
}

variable "security_group_name" {
  type        = string
  default     = "nat-security-group"
  description = "Security group name"
}

variable "subnet_params" {
    type = list(object({ 
        name = string, 
        zone = string, 
        cidr = list(string)
    }))

    default = [ {
        name = "final-work-subnet-a",
        zone = "ru-central1-a",
        cidr = ["10.10.1.0/24"]
    },
    {
        name = "final-work-subnet-b",
        zone = "ru-central1-b",
        cidr = ["10.10.2.0/24"]
    },
    {
        name = "final-work-subnet-d",
        zone = "ru-central1-d",
        cidr = ["10.10.3.0/24"]
    } ]
    
    description = "Subnet params"
}

variable "image_family" {
    type        = string
    default     = "ubuntu-2004-lts-oslogin"
    description = "Image family name"
}

variable "master_nodes_params" {
    type = object({ 
        name = string, 
        count = number, 
        cores = number,
        memory = number,
        core_fraction = number,
        disk_size = number,
        platform_id = string
    })

    default = {
        name = "master", 
        count = 1, 
        cores = 2,
        memory = 4,
        core_fraction = 100,
        disk_size = 20,
        platform_id = "standard-v3"
    }
    
    description = "Master node params"
}

variable "worker_nodes_params" {
    type = object({ 
        name = string, 
        count = number, 
        cores = number,
        memory = number,
        core_fraction = number,
        disk_size = number,
        platform_id = string
    })

    default = {
        name = "worker", 
        count = 1, 
        cores = 4,
        memory = 6,
        core_fraction = 100,
        disk_size = 20,
        platform_id = "standard-v3"
    }
    
    description = "Worker node params"
}

variable "nat_image_family" {
  type        = string
  default     = "nat-instance-ubuntu"
  description = "NAT image family id"
}

variable "nat_user_name" {
  type        = string
  default     = "ubuntu"
  description = "NAT user"
}

variable "nat_vm_params" {
    type = object({ 
        name = string, 
        cores = number,
        memory = number,
        core_fraction = number,
        disk_size = number,
        platform_id = string
    })

    default = {
        name = "nat", 
        cores = 2,
        memory = 2,
        core_fraction = 100,
        disk_size = 20,
        platform_id = "standard-v3"
    }
    
    description = "NAT VM params"
}

variable "lb_target_group_params" {
    type = object({ 
        name = string, 
        healthcheck_name = string,
        healthcheck_port = number
    })

    default = {
        name = "k8s-load-balancer-target-group", 
        healthcheck_name = "tcp",
        healthcheck_port = 22
    }
    
    description = "K8s load balancer target group params"
}

variable "lb_target_master_group_params" {
    type = object({ 
        name = string, 
        healthcheck_name = string,
        healthcheck_port = number
    })

    default = {
        name = "k8s-load-balancer-master-target-group", 
        healthcheck_name = "tcp",
        healthcheck_port = 22
    }
    
    description = "K8s load balancer master target group params"
}

variable "lb_name" {
  type        = string
  default     = "k8s-load-balancer"
  description = "K8s load balancer name"
}

variable "lb_listener_params" {
    type = list(object({ 
        name = string, 
        port = number,
        target_port = number,
        ip_version = string
    }))

    default = [ {
        name = "web-app", 
        port = 80,
        target_port = 30080,
        ip_version = "ipv4"
    } ]
    
    description = "K8s load balancer listener params"
}

variable "nat_security_group_egress_params" {
    type = list(object({ 
        protocol = string, 
        description = string, 
        cidr = list(string)
    }))

    default = [ {
        protocol = "ANY",
        description = "any",
        cidr = ["0.0.0.0/0"]
    } ]
    
    description = "NAT security group egress params"
}

variable "nat_security_group_ingress_params" {
    type = list(object({ 
        protocol = string, 
        description = string, 
        cidr = list(string)
    }))

    default = [ {
        protocol = "ANY",
        description = "any",
        cidr = ["0.0.0.0/0"]
    } ]
    
    description = "NAT security group ingress params"
}

variable "admin_vm_params" {
    type = object({ 
        name = string, 
        cores = number,
        memory = number,
        core_fraction = number,
        disk_size = number,
        platform_id = string
    })

    default = {
        name = "admin", 
        cores = 2,
        memory = 2,
        core_fraction = 100,
        disk_size = 20,
        platform_id = "standard-v3"
    }
    
    description = "Admin VM params"
}