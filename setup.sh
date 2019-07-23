#!/usr/bin/env bash

#create k3s cluster
k3d create
k3d ls

#wait for cluster to initialize before grabbing config
sleep 5 
export KUBECONFIG="$(k3d get-kubeconfig --name='k3s-default')"

#list pods
kubectl get pods --all-namespaces


#TODO insert gcp cred for image pull

#kubectl apply -f local-service.yaml,local-deployment.yaml
#kubectl apply -f redis-service.yaml,redis-deployment.yaml

#kubectl create namespace auth
#TODO push configmaps
#TODO push ambassador config
#TODO push api-auth
#TODO push mockOIDC?

sleep 5 
kubectl get pods --all-namespaces

echo "waiting to delete"
read -p "$*"
k3d delete 
