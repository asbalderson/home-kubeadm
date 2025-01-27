#!/bin/bash

function install-calico() {
    sudo snap install helm --classic
    helm repo add projectcalico 
    helm repo add projectcalico https://docs.tigera.io/calico/charts
    helm install calico projectcalico/tigera-operator --namespace tigera-operator
}
