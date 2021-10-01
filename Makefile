uid := $(shell id -u)
gid := $(shell id -g)

.PHONY: build

build:
	docker-compose build \
                       --build-arg UID=${uid} \
                       --build-arg GID=${gid} && \
	docker-compose run --no-deps web rails new . --force --database=postgresql && \
	cp database.yml.sample database/
