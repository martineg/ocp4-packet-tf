resource "null_resource" "haproxy" {

  provisioner "file" {
    destination = "/etc/haproxy/haproxy.cfg"
    content = templatefile("haproxy.tpl", {
      master0_ip   = packet_device.master[0].access_public_ipv4,
      master1_ip   = packet_device.master[1].access_public_ipv4,
      master2_ip   = packet_device.master[2].access_public_ipv4,
      worker0_ip   = packet_device.worker[0].access_public_ipv4,
      worker1_ip   = packet_device.worker[1].access_public_ipv4,
      bootstrap_ip = packet_device.bootstrap.access_public_ipv4
    })

  }

  provisioner "remote-exec" {
    inline = [
      "systemctl restart haproxy"
    ]
  }

  connection {
    type        = "ssh"
    host        = packet_device.bastion.access_public_ipv4
    private_key = file("${var.ocp4_private_key_file}")
  }

  depends_on = [
    packet_device.bootstrap,
    packet_device.master,
    packet_device.worker
  ]
}