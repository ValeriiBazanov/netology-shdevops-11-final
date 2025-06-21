variable "image_family" {
  type        = string
  default     = "ubuntu-2004-lts"
  description = "Image family name"
}

variable "platform_id" {
    type        = string
    default     = "standard-v1"
    description = "Platform Id"
}

variable "env_name" {
    type        = string
    default     = "web"
    description = "Instance name"
}

variable "disk_type" {
    type        = string
    default     = "network-hdd"
    description = "Disk type"
}

variable "disk_size" {
  type    = number
  default = 10
  description = "Disk size"
}

variable "zone_name" {
    type        = string
    description = "Zone"
}

variable "instance_count" {
  type    = number
  default = 1
  description = "Instance count"
}

variable "instance_cores" {
  type    = number
  default = 2
  description = "Instance cores"
}

variable "instance_memory" {
  type    = number
  default = 2
  description = "Instance memories"
}

variable "instance_core_fraction" {
  type    = number
  default = 20
  description = "Instance core fraction"
}

variable "preemptible" {
    type        = bool
    default     = true
    description = "Web preemptible"
}

variable "need_nat" {
    type        = bool
    default     = true
    description = "Web nat"
}

variable "metadata" {
  description = "for dynamic block 'metadata' "
  type        = map(string)
}

variable "labels" {
  description = "for dynamic block 'labels' "
  type        = map(string)
  default = {}
}

variable "subnet_id" {
    type        = string
    description = "Subnet id"
}

variable "security_group_ids" {
  type = list(string)
  default = []
}