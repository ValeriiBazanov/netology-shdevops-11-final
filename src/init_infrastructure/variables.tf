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

variable "nat_gateway_name" {
  type        = string
  default     = "finalwork-nat-gateway"
  description = "NAT gateway name"
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
        count = 3, 
        cores = 2,
        memory = 4,
        core_fraction = 100,
        disk_size = 20,
        platform_id = "standard-v3"
    }
    
    description = "Master node params"
}