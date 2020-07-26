#!/bin/bash
docker run -d --name consul-server --network=host -v /root/consul/data:/consul/data -v /root/consul/config:/consul/config consul:1.8 agent -server -bootstrap-expect=3 -ui -bind=< your server A IP > -client=0.0.0.0