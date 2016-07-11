# confroxy
5 Elements: Docker, Registrator, Consul, Consul Template, Nginx

## Create Dockerfile for your service

*Tools*
 - Gliderlabs Consul / server
 - Gliderlabs Registrator
 - Hashicorp Consul Template or Confd tool
 - ziyasal confroxy image that contains nginx and consul template 
 - 

_1. Alternative_
Another way to do that listen docker events manually (for example: [node-docker-monitor](https://github.com/Beh01der/node-docker-monitor))
and register or deregister services from consul then update your proxy tool (for example: [node-http-proxy](https://github.com/nodejitsu/node-http-proxy))


_run consul_

```sh
docker run -it -h node \
 -p 8500:8500 \
 -p 8600:53/udp \
 gliderlabs/consul-server \
 -server \
 -bootstrap \
 -advertise localhost \
 -log-level debug
```

_run registrator_

```sh
docker run -d \
    --name=registrator \
    --net=host \
    --volume=/var/run/docker.sock:/tmp/docker.sock \
    gliderlabs/registrator:latest \
      consul://localhost:8500

```

_run consul template and nginx service_

```sh
docker run -it  --net=host -e "CONSUL=127.0.0.1:8500" -e "SERVICE=trex-svc" -p 80:80 confroxy
```

_build your service image_

```sh
docker build -t trex/server .
```
_run your service_

```sh
docker run -it -e "SERVICE_NAME=trex-svc" -p 8000:80 trex/server
docker run -it -e "SERVICE_NAME=trex-svc" -p 8001:80 trex/server
docker run -it -e "SERVICE_NAME=trex-svc" -p 8001:80 trex/server
```