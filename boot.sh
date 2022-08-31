#!/bin/bash

create-mgmnt-cluster() {
    kind create cluster --config kind-mgmt-cluster-config.yaml --name mgmt
}

init-capi() {
    clusterctl init --infrastructure docker
}

install-argocd() {
    kubectl apply -f https://raw.githubusercontent.com/argoproj/argo-cd/stable/manifests/install.yaml
}

port-forward-argocd() {
    kubectl port-forward svc/argocd-server 8080:80
}

generate-cluster() {
    local -r name=$1
    local -r flavor=${2:-development}
    local -r infrastructure=${3:-docker}
    local -r k8s_ver=${4:-v1.24.0}
    local -r control_plane_machine_count=${5:-1}
    local -r worker_machine_count=${6:-1}
    clusterctl generate cluster $name \
               --flavor $flavor \
               --infrastructure $infrastructure \
               --kubernetes-version $k8s_ver \
               --control-plane-machine-count=${control_plane_machine_count} \
               --worker-machine-count=${worker_machine_count} \
               > capi-$name.yaml
}

