#!/usr/bin/env bash
ENV_BUILD:=$(shell test -s .env || cp .env.dist .env)

include .env

BUILD_CONTAINER_TAG=init_container_${SYMFONY_VERSION}_${PHP_VERSION}

help: ## Show the commands description
	@fgrep -h "##" $(MAKEFILE_LIST) | fgrep -v fgrep | sed -e 's/\\$$//' | sed -e 's/##//'

build: ## Build and initialize the project
ifeq (,$(wildcard ./app/composer.json))
		@echo "Project empty! Initializing Symfony ${SYMFONY_VERSION} over php ${PHP_VERSION}!"
		@docker rm ${BUILD_CONTAINER_TAG}_container -f || true
		@docker build --tag ${BUILD_CONTAINER_TAG} . \
		 --build-arg SYMFONY_VERSION=${SYMFONY_VERSION} \
		 --build-arg PHP_VERSION=${PHP_VERSION} \
		 -f ./docker/Dockerfile #--no-cache
		@docker run --detach --name=${BUILD_CONTAINER_TAG}_container ${BUILD_CONTAINER_TAG}
		@docker cp ${BUILD_CONTAINER_TAG}_container:/var/www/html/app/ ./
		@docker rm ${BUILD_CONTAINER_TAG}_container -f
		@cp app/.env app/env.dist
endif
	@docker-compose up -d --build --force-recreate
	@docker-compose exec php sh -c 'ls -ll && composer install'

run: ## Run an already built project
	@docker-compose up -d

stop: ## Stop an already running project
	@docker-compose stop

destroy: ## Destroy an already built project
	@docker-compose down
	@docker-compose rm -f
