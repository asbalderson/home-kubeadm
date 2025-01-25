#!/bin/bash

source ./utils/ssh-helper.sh
source ./utils/disable-swap.sh
source ./utils/install-containerd.sh
source ./utils/install-kubestar.sh

# host ip
# version
# cp ip

set -uex
ssh_func $1 disable_swap
ssh_func $1 install_containerd
ssh_func $1 install_kubestar $2
ssh_fuct $1 "sudo sysctl -w net.ipv4.ip_forward=1"
join_command=$(ssh ubuntu@$3 kubeadm token create --print-join-command)
ssh_func $1 $join_command
