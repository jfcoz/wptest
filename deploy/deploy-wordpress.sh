#!/bin/bash
cd $(dirname $0)
helm upgrade --install \
	--namespace wptest2 \
	--atomic \
	--debug \
	-f values-wptest2.yaml \
	wptest2 helm/wordpress/
