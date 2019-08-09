#!/usr/bin/env bash

#create k3s cluster
k3d create
k3d ls

#wait for cluster to initialize before grabbing config
sleep 5 
export KUBECONFIG="$(k3d get-kubeconfig --name='k3s-default')"

#list pods
kubectl get pods --all-namespaces




#insert gcp cred for image pull, per http://docs.heptio.com/content/private-registries/pr-gcr.html
    # --docker-username=_json_key \
    # --docker-password="$(cat k3d-gcr-access.json)" \
kubectl --namespace=default create secret docker-registry registry-secret \
    --docker-server=https://eu.gcr.io \
    --docker-password="$(gcloud auth print-access-token)" \
    --docker-username=oauth2accesstoken \
    --docker-email=k3d-gcr-read@cognitedata.iam.gserviceaccount.com

#wait for service account to come online
sleep 15
kubectl get serviceaccounts
kubectl patch serviceaccount default  -p '{"imagePullSecrets": [{"name": "registry-secret"}]}'
echo "account patched"
sleep 10

kubectl apply -f local-service.yaml,local-deployment.yaml
kubectl apply -f redis-service.yaml,redis-deployment.yaml

#kubectl create namespace auth
#TODO push configmaps
#TODO push ambassador config
#TODO push api-auth
#TODO push mockOIDC?

sleep 5 
kubectl get pods --all-namespaces

sleep 15
kubectl get pods --all-namespaces

echo "waiting to delete"
read -p "$*"
kubectl get pods --all-namespaces
k3d delete 
