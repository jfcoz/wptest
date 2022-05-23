#!/bin/bash
set -e
repo=jfcoz/wptest
tag=$(date +%Y%m%d-%H%M)
docker buildx build --platform linux/arm64 . -t $repo:$tag
docker push $repo:$tag
