# ocp4-packet-tf
Terraform scripts for bootstrapping an OCP4 cluster on Packet. 
Will register required DNS records in an AWS Route53 zone.

The bootstrap and instructions is based on scripts from https://github.com/jameslabocki/packetstrap

# Deployment

Populate `terraform.tfvars` with necessary credentials:
  - Packet.net auth token and project ID
  - RHSM credentials and pool ID for registering the bastion host
  - OpenShift pull secret from cloud.redhat.com
  - Paths to SSH public and private keys for logging into the bastion host
  - Cluster name and base domain

DNS records will be created in an AWS Route 53 zone that must exist and will be looked up based on name.
AWS credentials are not set as parameters to the provider and should be set in your shell

```bash
export AWS_ACCESS_KEY_ID=accesskey
export AWS_SECRET_ACCESS_KEY=secretkey
````

Run `terraform plan && terraform apply` to provision the infrastructure and start the cluster bootstrap process. When nodes have been provisioned, make sure to update HAproxy configuration on the bastion host with correct IP addresses.

Now you can watch and wait to see if the deployment returns

```bash
# ./openshift-install --dir=packetinstall wait-for bootstrap-complete --log-level=info 
INFO Waiting up to 20m0s for the Kubernetes API at https://api.packetlab.ocp4.lab.martineg.net:6443
```
