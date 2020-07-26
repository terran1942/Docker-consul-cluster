#!/bin/bash
docker run -d --name consul-client --network=host -v /root/consul/data:/consul/data -v /root/consul/config:/consul/config consul:1.8 agent -bind=<your client IP> -retry-join=<your server A IP>