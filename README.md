# confroxy
5 Elements:  Docker, Registrator, Consul, Consul Template, Nginx

## Create Dockerfile for your service

*Tools*
 - [Gliderlabs Consul / server](https://github.com/gliderlabs/docker-consul)
 - [Gliderlabs Registrator](https://github.com/gliderlabs/registrator)
 - Hashicorp Consul Template or Confd tool
    - [Consul Template](https://github.com/hashicorp/consul-template)
    - [Confd](https://github.com/kelseyhightower/confd)
 - ziyasal [confroxy](https://github.com/ziyasal/confroxy) image that contains nginx and consul template 
 - 
 
_Other Alternative_  
Another way to do that listen docker events manually (for example: [node-docker-monitor](https://github.com/Beh01der/node-docker-monitor))
and register or deregister services from consul then update your proxy tool (for example: [node-http-proxy](https://github.com/nodejitsu/node-http-proxy))


#### run consul

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

####  run registrator

```sh
docker run -d \
    --name=registrator \
    --net=host \
    --volume=/var/run/docker.sock:/tmp/docker.sock \
    gliderlabs/registrator:latest \
      consul://localhost:8500

```

####  run confroxy (preconfigured _consul template_ and _nginx_ service)

```sh
docker run -it  --net=host -e "CONSUL=127.0.0.1:8500" -e "SERVICE=trex-svc" -p 80:80 confroxy
```

####  build your service image

```sh
docker build -t trex/server .
```
####  run your service instances

_Docker scale will do that (:_ 

```sh
docker run -it -e "SERVICE_NAME=trex-svc" -p 8000:80 trex/server
docker run -it -e "SERVICE_NAME=trex-svc" -p 8001:80 trex/server
docker run -it -e "SERVICE_NAME=trex-svc" -p 8001:80 trex/server
```
