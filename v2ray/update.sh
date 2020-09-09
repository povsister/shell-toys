#!/bin/bash
IMAGE=v2fly/v2fly-core

docker stop myray
docker rm myray

for i in $(docker images --format '{{.Repository}}|{{.ID}}'); do
  repo=$(echo -n $i | cut -d '|' -f1)
  id=$(echo -n $i | cut -d '|' -f2)
  if [ "$repo" == "$IMAGE" ]; then
    docker rmi $id
  fi
done

docker run -d --name myray -v /etc/v2ray:/etc/v2ray -p 2331:2331/tcp -p 8001:8001/tcp -p 8002:8002/udp $IMAGE
