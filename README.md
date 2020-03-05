# k3d-test-cluster
A local kubernetes test cluster, using k3d

Start a local k3d (k3s in docker) based kubernetes cluster running CDF services.
- [x] generate registries.yaml file

Services included:
- [ ] vault
- [ ] ambassador
- [ ] redis
- [ ] iam-db
- [ ] iam-db-migration
- [ ] iam-db-prepopulation
- [ ] api-auth
- [ ] ratelimiting
- [ ] backend services


## Running:
- make sure you have k3d installed: https://github.com/rancher/k3d
- make sure you are logged in to a gcloud account that can pull images from the cognite gcr
- run: 
```
$ ./setup.sh
```

