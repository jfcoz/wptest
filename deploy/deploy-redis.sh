#!/bin/bash
cd $(dirname $0)
helm upgrade --install \
	--namespace wptest2 \
	--atomic \
	--debug \
	-f values-wptest2-redis.yaml \
	wptest2-redis helm/redis/
