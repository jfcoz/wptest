#!/bin/bash
cd $(dirname $0)
kubectx minikube
helm upgrade --install \
	--namespace wptest3 \
	--atomic \
	--debug \
	-f values-wptest3.yaml \
	wptest2 helm/wordpress/
