# Docker consul cluster
Build multi-host Consul cluster by the Docker

## Background
We always use the Consul for service discovery and config, but single host development mode is unrealiable.


Build cluster by the Docker is simple, fast process, this project includes all steps of build Consul cluster fastly.

Requirement:
+ Consul servers, 3 hosts.
+ Consul clients, any number hosts.

## Get started
This project uses [docker](https://docs.docker.com/install/),
check them out if you do not have them locally installed.

### Consul server A
On the server A, replace < your server IP > in consul-a.sh, then run it, the shell following:
``` bash
docker run -d --name consul-server --network=host -v /root/consul/data:/consul/data -v /root/consul/config:/consul/config consul:1.7 agent -server -bootstrap-expect=3 -ui -bind=<your server A IP> -client=0.0.0.0
```

### Consul server B
On the server B, replace < your server B IP > and < your server A IP > in 'consul-b.sh', then run it.
```bash
docker run -d --name consul-server --network=host -v /root/consul/data:/consul/data -v /root/consul/config:/consul/config consul:1.7 agent -server -ui -bind=<your server B IP> -client=0.0.0.0 -join=<your server A IP>
```

### Consul server C
On the server C, execute same process with server B.
``` bash
docker run -d --name consul-server --network=host -v /root/consul/data:/consul/data -v /root/consul/config:/consul/config consul:1.7 agent -server -ui -bind=<your server C IP> -client=0.0.0.0 -join=<your server A IP>
```

### Consul client
On the client, replace < your client IP > and < your server A IP > in 'consul-client.sh', then run it connect to cluster, the shell following:
``` bash
docker run -d --name consul-client --network=host -v /root/consul/data:/consul/data -v /root/consul/config:/consul/config consul:1.7 agent -bind=<your client IP> -retry-join=<your server A IP>
```
