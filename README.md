## Create Dockerfile for your service


*Tools*
 - Gliderlabs Consul / server
 - Cliderlabs Registrator
 - Hashicorp Consul Template or Confd tool
 - ziyasal simplex image that contains nginx and consul template 
 - Your service

_1. Alternative_
The another way to do that listen docker events manually 
and register or deregister services?containers from consul then update your proxy tool such as node-proxy


_build your image_

```sh
docker build -t simplex/server .
```

_start your server_
```sh
docker run -it  -p 8000:80 simplex/server
```

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


_install  registrator_

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
docker run -it  --net=host -e "CONSUL=127.0.0.1:8500" -e "SERVICE=simple" -p 80:80 confroxy
```

_run your service_

```sh
docker run -it -e "SERVICE_NAME=simple" -p 8000:80 simplex/server

docker run -it -e "SERVICE_NAME=simple" -p 8001:80 simplex/server
```







_register service to consul (manually demo)_

```sh
curl -XPUT \
127.0.0.1:8500/v1/agent/service/register \
-d '{
 "ID": "simple_instance_1",
 "Name":"simple",
 "Port": 8000, 
 "tags": ["tag"]
}'
```

