.PHONY: up down obs metrics build deploy port-forward logs
SHELL := /bin/bash

up:
	./scripts/up.sh

down:
	./scripts/down.sh

obs:
	./scripts/obs.sh

metrics:
	./scripts/metrics.sh

build:
	./scripts/build_push_local.sh

deploy:
	./scripts/deploy.sh

port-forward:
	kubectl -n demo port-forward svc/tiny-web 8080:80

logs:
	kubectl -n demo logs -l app=tiny-web -f --tail=200
