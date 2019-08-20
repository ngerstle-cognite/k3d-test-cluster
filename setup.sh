#!/usr/bin/env bash

#create k3s cluster
k3d create
k3d ls

#wait for cluster to initialize before grabbing config
sleep 5 
export KUBECONFIG="$(k3d get-kubeconfig --name='k3s-default')"



#insert gcr access token for image pull
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

#TODO We don't use helm/traefik, so remove:
kubectl delete -n kube-system helmcharts traefik

kubectl apply -f local-manifest.yaml
kubectl apply -f redis-manifest.yaml

#kubectl create namespace auth
#TODO push configmaps
#TODO push ambassador
#TODO push api-auth
#TODO push ratelimiting
#TODO push backend services as required


sleep 5 
kubectl get pods --all-namespaces
echo "This may take a while, you may want to run '$ watch -n 5 KUBECONFIG=\"$(k3d get-kubeconfig --name=\'k3s-default\')\" kubectl get pods --all-namespaces' "
sleep 120
kubectl get pods --all-namespaces

echo "waiting to delete"
read -p "$*"
kubectl get pods --all-namespaces
k3d delete