#! /bin/bash

KUBE_CONFIG=/root/packetinstall/auth/kubeconfig
CERBERUS_CONFIG=$PWD/config.yaml
podman pull quay.io/openshift-scale/cerberus

podman run --name=cerberus \
    --net=host \
    -v $KUBE_CONFIG:/root/.kube/config:Z \
    -v $CERBERUS_CONFIG:/root/cerberus/config/config.yaml:Z \
    -d \
    quay.io/openshift-scale/cerberus:latest

