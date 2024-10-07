.PHONY: helo build build-local up down logs ps test
.DEFAULT_GOAL := help

DOCKER_TAG := latest
build: ## Build focker image to deploy
	docker build -t budougumi0617/gotodo:${DOCKER_TAG} \
					--target deploy ./

build-local: ## build docker image to local devlopment
	docker compose build --no-cache

up: ## Do docker compose up with hot reload
	docker compose up -d

down: ## Do docker compose down
	docker compose down

logs: ## Tail docker compose logs
	docker compose logs -f

ps: ## Check container status
	docker compose ps

test: ## Execute tests
	go test -race -suffle=on ./...

help: ## Show options
	@grep -E '^[a-zA-Z_-]+:.*?## .*$$' ${MAKEFILE_LIST} | \
		awk 'BEGIN {FS = ":.*?## "}; {printf "\033[36m%-20s\033[0m %s\n", $$1, $$2}'
