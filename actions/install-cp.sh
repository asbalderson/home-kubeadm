#!/bin/bash

source ./utils/ssh-helper.sh
source ./utils/disable-swap.sh
source ./utils/install-containerd.sh
source ./utils/install-kubestar.sh

function install() {
    set -eux
    # requires 2 arguments
    # pod network cidr       -> $1
    # api-server-extra-sans  -> $2
    # the extra-sans should inlude the hostnames and ipaddresses of expected other nodes
    # ie. tonfa,katana,kama,ip1,ip2

    # configure networking
    sudo sysctl -w net.ipv4.ip_forward=0

    # setup the cluster
    sudo kubeadm init --pod-network-cidr=$1 --api-server-extra-sans=$2

    sudo cat /etc/kubernetes/admin.conf
}

ssh_func $1 disable_swap
ssh_func $1 install_containerd
ssh_func $1 install_kubestar $2
ssh_func $1 install ${@:3}
