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

variable "service_account_name" {
  type        = string
  default     = "cloud-admin"
  description = "Service account cloud admin name"
}

variable "service_account_roles" {
  type        = list(string)
  default     = ["storage.editor", "kms.keys.encrypter", "kms.keys.decrypter", "container-registry.images.pusher", "container-registry.images.puller"]
  description = "Service account cloud admin roles"
}

variable "symmetric_key_name" {
  type        = string
  default     = "terraform-backend-vbazanov-final"
  description = "Symmetric key name"
}

variable "symmetric_key_default_algorithm" {
  type        = string
  default     = "AES_128"
  description = "Default algorithm for symmetric key"
}

variable "symmetric_key_rotation_period" {
  type        = string
  default     = "8760h"
  description = "Rotation period for symmetric key"
  }

variable "bucket_name" {
  type        = string
  default     = "terraform-backend-vbazanov-final"
  description = "Bucket for terraform backend"
}

variable "bucket_sse_algorithm" {
  type        = string
  default     = "aws:kms"
  description = "Bucket sse algorithm"
}

variable "profile_name" {
  type        = string
  default     = "finalwork"
  description = "Profile name"
}

variable "registry_name" {
  type        = string
  default     = "finalwork-registry"
  description = "Registry name"
}