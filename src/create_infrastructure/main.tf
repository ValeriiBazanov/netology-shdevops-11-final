data "template_file" "cloudinit" {
  template = file("./cloud-init.yml")
  vars = {public_key = var.public_key}
}