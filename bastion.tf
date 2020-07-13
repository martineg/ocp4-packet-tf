# bastion host
resource "packet_device" "bastion" {
  plan             = "c1.small.x86"
  hostname         = "mgmt"
  facilities       = local.packet_facility
  operating_system = "rhel_7"
  billing_cycle    = local.packet_billing_cycle
  project_id       = var.packet_project_id

  provisioner "file" {
    destination = "/root/bootstrap.sh"
    content = templatefile("bootstrap.tpl", {
      rhsm_user_name       = var.rhsm_user_name
      rhsm_password        = var.rhsm_password
      rhsm_pool_id         = var.rhsm_pool_id
      ocp4_cluster_name    = var.ocp4_cluster_name
      ocp4_base_domain     = var.ocp4_base_domain
      ocp4_install_version = var.ocp4_install_version
      pull_secret          = file(var.ocp4_pull_secret_file)
      ssh_key              = file(var.ocp4_public_key_file)
    })

    connection {
      type        = "ssh"
      host        = self.access_public_ipv4
      private_key = file("${var.ocp4_private_key_file}")
    }
  }

  provisioner "remote-exec" {
    inline = [
      "chmod +x /root/bootstrap.sh",
      "/root/bootstrap.sh"
    ]

    connection {
      type        = "ssh"
      host        = self.access_public_ipv4
      private_key = file("${var.ocp4_private_key_file}")
    }
  }
}