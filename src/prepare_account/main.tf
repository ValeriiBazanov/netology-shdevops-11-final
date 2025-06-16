resource "yandex_iam_service_account" "service_account" {
  name        = var.service_account_name
  description = "Service account cloud admin"
}

resource "yandex_resourcemanager_folder_iam_member" "service_account_role" {
  count     = length(var.service_account_roles)
  folder_id = var.folder_id
  role      = var.service_account_roles[count.index]
  member    = "serviceAccount:${yandex_iam_service_account.service_account.id}"
}

resource "yandex_iam_service_account_static_access_key" "service_account_static_key" {
  service_account_id = yandex_iam_service_account.service_account.id
  description        = "Static access key for cloud admin"
}

resource "yandex_kms_symmetric_key" "symmetric_key" {
  name              = var.symmetric_key_name
  description       = "Symmetric key for bucket encription"
  default_algorithm = var.symmetric_key_default_algorithm
  rotation_period   = var.symmetric_key_rotation_period
}

resource "yandex_storage_bucket" "bucket_terraform_backend" {
  bucket     = var.bucket_name
  acl        = "private"
  access_key = yandex_iam_service_account_static_access_key.service_account_static_key.access_key
  secret_key = yandex_iam_service_account_static_access_key.service_account_static_key.secret_key

  server_side_encryption_configuration {
    rule {
      apply_server_side_encryption_by_default {
        kms_master_key_id = yandex_kms_symmetric_key.symmetric_key.id
        sse_algorithm     = var.bucket_sse_algorithm
      }
    }
  }

  anonymous_access_flags {
    read        = false
    list        = false
    config_read = false
  }
}