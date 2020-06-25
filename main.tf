terraform {
  required_providers {
    packet = "~> 2.9"
  }
}
provider "packet" {
  auth_token = var.auth_token
}

locals {
  packet_billing_cycle  = "hourly"
  packet_cluster_os     = "custom_ipxe"
  packet_facility       = ["ams1"]
  packet_plan_bootstrap = "c1.small.x86"
  packet_plan_cluster   = "c2.medium.x86"
}