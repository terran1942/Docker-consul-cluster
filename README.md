# Docker consul cluster
Build multi-host Consul cluster by the Docker

## Background
We always use the Consul for service discovery and config, but single host development mode is unrealiable.


Build cluster by the Docker is simple, fast process, this project includes all steps of build Consul cluster fastly.
And we will enable ACL to security access Consul cluster.

Requirement:
+ Consul servers, 3 hosts.
+ Consul clients, any number hosts.

## Get started
This project uses [docker](https://docs.docker.com/install/),
check them out if you do not have them locally installed.

+ Pull Consul image on every hosts, command following:
``` bash
docker pull consul:1.7
```

+ Replace server token in server.yml, such as following:
``` yaml
{
  "datacenter": "dc",
  "server": true,
  "acl":{
    "enabled":true,
    "default_policy":"deny",
    "down_policy":"extend-cache",
    "enable_token_persistence":true
  }
}
```

+ Replace client token in client.yml, such as following:
``` yaml
{
  "datacenter": "dc",
  "acl":{
    "enabled":true,
    "default_policy": "deny",
    "enable_token_persistence": true
  }
}
```

+ Sync consul-a.sh, consul-b.sh, consul-c.sh to 3 Consul servers respectively.
+ Sync server.yml to **/root/consul/config/server.yml** in 3 Consul servers.
+ Sync client.yml to **/root/consul/config/client.yml** in any clients.

### Consul servers
On the server A, replace **< your server IP >** in consul-a.sh, then run it.

#### Create the bootstrap token
```bash
consul acl bootstrap
```
```bash
AccessorID:       f989ff1d-6598-485c-9c46-06708ab5fdf7
SecretID:         dbc53eec-5dde-4b70-bd28-7496831b2e65
Description:      Bootstrap Token (Global Management)
Local:            false
Create Time:      2020-07-04 07:06:51.737974744 +0000 UTC
Policies:
   00000000-0000-0000-0000-000000000001 - global-management
```
#### Create agent policy
```hcl
node_prefix "" {
   policy = "write"
}
service_prefix "" {
   policy = "read"
}
```
```bash
consul acl policy create -name "agent-token" -description "Agent Token Policy" -rules @agent-policy.hcl
```

#### Create Consul agent token
```bash
consul acl token create -description "Agent Token" -policy-name "agent-token"
```
```bash
AccessorID:   499ab022-27f2-acb8-4e05-5a01fff3b1d1
SecretID:     da666809-98ca-0e94-a99c-893c4bf5f9eb
Description:  Agent Token
Local:        false
Create Time:  2018-10-19 14:23:40.816899 -0400 EDT
Policies:
   fcd68580-c566-2bd2-891f-336eadc02357 - agent-token
```

#### Add the agent token to all Consul servers
+ Add agent token to ***server.json*** ***client.json***
```json
{
  "primary_datacenter": "dc1",
  "acl": {
    "enabled": true,
    "default_policy": "deny",
    "down_policy": "extend-cache",
    "tokens": {
      "agent": "da666809-98ca-0e94-a99c-893c4bf5f9eb"
    }
  }
}
```
+ On the server B, replace **< your server B IP >** and **< your server A IP >** in 'consul-b.sh', then run it.
+ On the server C, execute same process with server B.
+ On the client, replace < your client IP > and **< your server A IP >** in 'consul-client.sh', then run it connect to cluster.

## Usage
It is recommended to install the Consul client on all microservice servers, only allow Consul client connect to Consul server cluster, then microservice connect to Consul client.

In micro-services, configure Consul settings，for example in Spring Cloud bootstrap.yml:
``` yaml
spring:
  application:
    name: application
  cloud:
    consul:
      enabled: true
      host: localhost
      port: 8500
      discovery:
        fail-fast: true
        prefer-ip-address: true
        acl-token: '55c5c5d2-362b-4b78-8667-4c2e44e3faeb'
      config:
        enabled: true
        watch:
          enabled: true
          delay: 1000
        format: yaml
        acl-token: '55c5c5d2-362b-4b78-8667-4c2e44e3faeb'
```


## License

MIT © Yongliang Li