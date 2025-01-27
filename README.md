# Overview

This repo contains scripts used to tearing down and brining up a k8s cluster using kubeadm on a series of nucs running ubuntu in a home lab. It is a work in progress and wont alawys reflect the working state or the current tooling of kubeadm.

## Contents

### Actions

Contains scripts for setting up and tearing down the cluster

#### Actions/Utils

Generic tools used by multiple scripts

### Resources

Deployment yaml for bringing up the CNI an other tools inside the cluster

## How To's

The only assumption here is that the user can SSH from this host, tothe remote hosts to the user ubuntu.

### Deploying the controller node

```
./actions/install-cp.sh <host ip address> <k8s-version> <pod network cidr> <comma sperated list of additional sans, usually the hostnames for the controller and wokers, and their ip addersses>
```

This action should print out the join command and then cat out the kubeconf for connecting to the cluster

### Adding a woker node

```
./actions/install-worker.sh <worker ip address> <k8s version> <host ip address>
```

From here you should be able to run `kubectl node list` to see the node joined but not ready, you can watch `kubectl get po -A` and watch the pods come up on the node

### Removing the worker node (or the cp node at the end)
```
./actions/remove-unit.sh <host ip address>
```

It is assumed that the local host can run kubectl commands against the cluster.
There is no vlaidation that the current kubeconf and context in kubectl is for tgis cluster.
This will not fully set the unit back to its default space, as swap will still be disabled, and the network forwarding will still be set as it was left.

### Setting up the CNI

```
./actions/install-calico.sh
```

This uses helm to install calico and set up the tigera operator which manages calico

### Setting up metrics

```
kubectl apply -f resources/metrics-server.yaml
```

If the metrics server is failing to start, it may be because the SANS were not set right on the controller, these can be updated on the controller node after deployment by updating the certs step of the init on the controller node.
```
sudo kubeadm init phase certs apiserver --apiserver-cert-extra-sans=<extra sans>
sudo killall -s SIGTERM kube-apiserver
```

