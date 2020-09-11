terraform {
  required_providers {
    packet = {
      source  = "terraform-providers/packet"
      version = "~> 2.9"
    }
    aws = {
      source  = "hashicorp/aws"
      version = "~> 2.68"
    }
    null = {
      source  = "hashicorp/null"
      version = "~> 2.1"
    }
  }
}
provider "packet" {
  auth_token = var.packet_auth_token
}

provider "aws" {
  region = "eu-north-1"
}

locals {
  packet_billing_cycle  = "hourly"
  packet_cluster_os     = "custom_ipxe"
  packet_facility       = ["ams1"]
  packet_plan_bootstrap = "c1.small.x86"
  packet_plan_cluster   = "c2.medium.x86"
}