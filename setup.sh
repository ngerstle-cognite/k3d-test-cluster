#!/usr/bin/env bash


CLUSTERNAME="cdp-lite"

#create registries.yaml, if not exists
if [ ! -f registries.yaml ]; then
    echo "Registries file not found, creating..."
    cat <<- EOF > registries.yaml
	mirrors:
	  prog-cognite-gcr:
	    endpoint:
	      - https://eu.gcr.io
	configs:
	  prog-cognite-gcr:
	    auth:
	      username: not@val.id
	EOF
    token=$(jq -r '.auths."https://eu.gcr.io".auth' ~/.docker/config.json)
    echo "      password: $token" >> registries.yaml 

fi

#create k3s cluster
k3d create \
  --name $CLUSTERNAME \
  --registries-file registries.yaml \
  --server-arg --no-deploy=traefik \

k3d ls

#wait for cluster to initialize before grabbing config
sleep 100
export KUBECONFIG="$(k3d get-kubeconfig --name=$CLUSTERNAME)"
kubectl get pods --all-namespaces
read -p "$*"


## TODO apply all manifests here...
# in tiers?
# kubectl apply -f local-manifest.yaml


echo "This may take a while, you may want to run '$ watch -n 5 KUBECONFIG=\"$(k3d get-kubeconfig --name=\'k3s-default\')\" kubectl get pods --all-namespaces' "
sleep 120
kubectl get pods --all-namespaces

echo "waiting to delete"
read -p "$*"
kubectl get pods --all-namespaces
k3d delete --name $CLUSTERNAME
