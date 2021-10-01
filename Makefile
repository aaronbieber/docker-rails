uid := $(shell id -u)
gid := $(shell id -g)

.PHONY: bootstrap build createdb clean

bootstrap:
	cp -v Gemfile.sample Gemfile && \
	cp -v Gemfile.lock.sample Gemfile.lock && \
	chmod a+w * && \
	docker-compose build \
                       --build-arg UID=${uid} \
                       --build-arg GID=${gid} && \
	docker-compose run --no-deps web rails new . --force --database=postgresql && \
	docker-compose build \
                       --build-arg UID=${uid} \
                       --build-arg GID=${gid} && \
	cp -v database.yml.sample config/database.yml

build:
	docker-compose build \
                       --build-arg UID=${uid} \
                       --build-arg GID=${gid}

createdb:
	docker-compose run web rake 'db:create' && \
	echo "You should now reset ownership of the tmp/db directory to your user." && \
	echo "If you do not, running rails or rake commands may fail."

# todo: this is super destructive; it deletes ALL images/containers on the system!
#       probably make it not do that
clean:
	docker container ls -aq | xargs docker container rm; \
	docker image ls -aq | xargs docker image rm
