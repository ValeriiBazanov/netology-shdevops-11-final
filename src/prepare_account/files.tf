resource "local_file" "aws_credentials" {
    content = templatefile("${path.module}/credential.tftpl",
    { 
        static_key = yandex_iam_service_account_static_access_key.service_account_static_key,
        profile_name = var.profile_name
    }  )

    filename = "${abspath(path.module)}/../../.aws/credentials"
}