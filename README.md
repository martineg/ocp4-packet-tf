# ocp4-packet-tf
Terraform scripts for bootstrapping an OCP4 cluster on Packet

Populate `terraform.tfvars` with necessary credentials:
  - Packet.net auth token and project ID
  - RHSM credentials and pool ID for registering the bastion host
  - OpenShift pull secret from cloud.redhat.com
  - Paths to SSH public and private keys for logging into the bastion host
  
