# cluster hosts
## bootstrap
resource "packet_device" "bootstrap" {
  plan             = local.packet_plan_bootstrap
  hostname         = "bootstrap"
  facilities       = local.packet_facility
  operating_system = local.packet_cluster_os
  ipxe_script_url  = "http://${packet_device.bastion.access_public_ipv4}:8080/packetstrap/bootstrap.boot"
  billing_cycle    = local.packet_billing_cycle
  project_id       = var.project_id

  depends_on = [
    packet_device.bastion
  ]
}

## masters
resource "packet_device" "master" {
  count = 3

  plan             = local.packet_plan_cluster
  hostname         = "master${count.index + 1}"
  facilities       = local.packet_facility
  operating_system = local.packet_cluster_os
  ipxe_script_url  = "http://${packet_device.bastion.access_public_ipv4}:8080/packetstrap/master.boot"
  billing_cycle    = local.packet_billing_cycle
  project_id       = var.project_id

  depends_on = [
    packet_device.bastion
  ]

}

## workers
resource "packet_device" "worker" {
  count = 2

  plan             = local.packet_plan_cluster
  hostname         = "worker${count.index + 1}"
  facilities       = local.packet_facility
  operating_system = local.packet_cluster_os
  ipxe_script_url  = "http://${packet_device.bastion.access_public_ipv4}:8080/packetstrap/worker.boot"
  billing_cycle    = local.packet_billing_cycle
  project_id       = var.project_id

  depends_on = [
    packet_device.bastion
  ]
}