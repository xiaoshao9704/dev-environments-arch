#!/bin/bash
TAG=$1
if [[ "$TAG" == "" ]]
then
    TAG="latest"
fi

if [[ "$2" == "" ]]
then
    docker buildx build --platform linux/amd64 -t xiaoshao97/dev-environments-arch:$TAG $(cd $(dirname $0) && pwd -P) --load
else
    docker buildx build --platform linux/amd64 -t xiaoshao97/dev-environments-arch:$TAG $(cd $(dirname $0) && pwd -P) --push
fi