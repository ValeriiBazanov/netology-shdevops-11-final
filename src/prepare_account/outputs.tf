output "service_account_id" {
  value = yandex_iam_service_account.service_account.id
}

output "bucket_name" {
  value = yandex_storage_bucket.bucket_terraform_backend.bucket
}

output "sa_access_key" {
  value     = yandex_iam_service_account_static_access_key.service_account_static_key.access_key
  sensitive = true
}

output "sa_secret_key" {
  value     = yandex_iam_service_account_static_access_key.service_account_static_key.secret_key
  sensitive = true
}