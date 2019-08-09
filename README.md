# k3d-test-cluster
A local kubernetes test cluster, using k3d

Start a local k3d (k3s in docker) based kubernetes cluster running CDF services.
Services included:
- [x] local service (the emulater primary mysql database, some cloud emulators)
- [x] redis
- [ ] ambassador
- [ ] api-auth
- [ ] ratelimiting
- [ ] backend services?


## Running:
- make sure you have k3d installed: https://github.com/rancher/k3d
- make sure you are logged in to a gcloud account that can pull images from the cognite gcr
- run: 
```
$ ./setup.sh
```
