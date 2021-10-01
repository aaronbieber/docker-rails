uid := $(shell id -u)
gid := $(shell id -g)

.PHONY: build

build:
	mv -v Gemfile.sample Gemfile && \
	mv -v Gemfile.lock.sample Gemfile.lock && \
	chmod a+w * && \
	docker-compose build \
                       --build-arg UID=${uid} \
                       --build-arg GID=${gid} && \
	docker-compose run --no-deps web rails new . --force --database=postgresql && \
	mv -v database.yml.sample config/
