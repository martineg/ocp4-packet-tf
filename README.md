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
```

Run `terraform plan && terraform apply -auto-approve` to provision the infrastructure and start the cluster bootstrap process. After the VMs and other infra has been provisioned, Terraform will output the IP of the bastion host which you can now log into to complete the deployment.

```
Apply complete! Resources: 15 added, 0 changed, 0 destroyed.

Outputs:

bastion_public_ip = 147.75.100.225
```

```bash
# ./openshift-install --dir=packetinstall wait-for bootstrap-complete --log-level=info 
INFO Waiting up to 20m0s for the Kubernetes API at https://api.packetlab.ocp4.lab.martineg.net:6443
INFO API v1.18.3+b0068a8 up
INFO Waiting up to 40m0s for bootstrapping to complete...
INFO It is now safe to remove the bootstrap resources
```

When bootstrapping is complete, remove the _bootstrap_ node from _/etc/haproxy.conf_ and reload haproxy.

```bash
[root@mgmt ~]# mv /etc/haproxy/haproxy.cfg /etc/haproxy/haproxy.cfg.orig
[root@mgmt ~]# grep -v bootstrap /etc/haproxy/haproxy.cfg.orig > /etc/haproxy/haproxy.cfg
[root@mgmt ~]# systemctl reload haproxy
```

Now approve the CSR of the deployed worker nodes before waiting for the installation to complete.
```bash
  # export KUBECONFIG=$PWD/packetinstall/auth/kubeconfig
  # ./oc get csr
  NAME        AGE     SIGNERNAME                                    REQUESTOR                                                                   CONDITION
  csr-24kxq   13m     kubernetes.io/kubelet-serving                 system:node:master2                                                         Approved,Issued
  csr-4nsbm   13m     kubernetes.io/kubelet-serving                 system:node:master3                                                         Approved,Issued
  csr-5jfxx   4m56s   kubernetes.io/kube-apiserver-client-kubelet   system:serviceaccount:openshift-machine-config-operator:node-bootstrapper   Pending
  csr-6xf6v   14m     kubernetes.io/kube-apiserver-client-kubelet   system:serviceaccount:openshift-machine-config-operator:node-bootstrapper   Approved,Issued
  csr-hlgbb   14m     kubernetes.io/kube-apiserver-client-kubelet   system:serviceaccount:openshift-machine-config-operator:node-bootstrapper   Approved,Issued
  csr-l7dkl   4m55s   kubernetes.io/kube-apiserver-client-kubelet   system:serviceaccount:openshift-machine-config-operator:node-bootstrapper   Pending
  csr-nqqg9   14m     kubernetes.io/kube-apiserver-client-kubelet   system:serviceaccount:openshift-machine-config-operator:node-bootstrapper   Approved,Issued
  csr-ztjpr   14m     kubernetes.io/kubelet-serving                 system:node:master1                                                         Approved,Issued
  # ./oc get csr -o go-template='{{range .items}}{{if not .status}}{{.metadata.name}}{{"\n"}}{{end}}{{end}}' | xargs ./oc adm certificate approve
certificatesigningrequest.certificates.k8s.io/csr-5jfxx approved
certificatesigningrequest.certificates.k8s.io/csr-l7dkl approved

# ./oc get nodes
NAME      STATUS     ROLES    AGE   VERSION
master1   Ready      master   15m   v1.18.3+47c0e71
master2   Ready      master   15m   v1.18.3+47c0e71
master3   Ready      master   15m   v1.18.3+47c0e71
worker1   NotReady   worker   40s   v1.18.3+47c0e71
worker2   NotReady   worker   40s   v1.18.3+47c0e71
```

```
#  ./openshift-install --dir=packetinstall wait-for install-complete --log-level=info
INFO Waiting up to 30m0s for the cluster at https://api.packetlab.ocp4.lab.martineg.net:6443 to initialize...
INFO Waiting up to 10m0s for the openshift-console route to be created...
INFO Install complete!
INFO To access the cluster as the system:admin user when using 'oc', run 'export KUBECONFIG=/root/packetinstall/auth/kubeconfig'
INFO Access the OpenShift web-console here: https://console-openshift-console.apps.packetlab.ocp4.lab.martineg.net
INFO Login to the console with user: "kubeadmin", and password: "xxxxxxx"
````
