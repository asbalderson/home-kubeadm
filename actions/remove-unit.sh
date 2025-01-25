#!/bin/bash

source ./utils/ssh-helper.sh

function uninstall() {
    set -uex
    sudo kubeadm reset
    sudo apt-get purge kubeadm kubectl kubelet containerd --assume-yes
    sudo apt-get auto-remove --assume-yes
}

set -uex
remote_hostname=$(ssh ubuntu@$1 hostname)

kubectl drain $remote_hostname --ignore-daemonsets=true --delete-emptydir-data=true --force 
kubectl delete node $remote_hostname --force
ssh_func $1 uninstall
