#!/bin/bash
# build is done via buildx and needs quemu-user-static
set -e
repo=jfcoz/wptest
tag=$(date +%Y%m%d-%H%M)
echo building tag $tag
docker buildx build \
	--pull \
	--platform linux/arm64,linux/amd64 \
	--cache-from $repo:cache \
	--cache-to $repo:cache \
	-t $repo:$tag \
	-t $repo:latest \
	--push \
	.
