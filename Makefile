DOCKER_IMAGE_REPO=quay.io/brancz/blog
DOCKER_IMAGE_TAG=$(shell git rev-parse --short HEAD)
DOCKER_IMAGE_NAME=$(DOCKER_IMAGE_REPO):$(DOCKER_IMAGE_TAG)

all: serve

serve: container
	docker run --rm -it -p 8080:80 $(DOCKER_IMAGE_NAME)

container:
	docker build -t $(DOCKER_IMAGE_NAME) .

serve-dev: container-dev
	docker run --rm -it -p 8080:80 $(DOCKER_IMAGE_NAME)-dev

container-dev:
	docker build -f Dockerfile.dev -t $(DOCKER_IMAGE_NAME)-dev .

