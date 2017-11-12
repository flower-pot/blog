IMAGE_TAG=$(shell git rev-parse --short HEAD)

BLOG_IMAGE_REPO=quay.io/brancz/blog
BLOG_IMAGE_NAME=$(BLOG_IMAGE_REPO):$(IMAGE_TAG)

MTAIL_IMAGE_REPO=quay.io/brancz/blog-mtail
MTAIL_IMAGE_NAME=$(MTAIL_IMAGE_REPO):$(IMAGE_TAG)

all: serve

serve: container
	docker run --rm -it -p 8080:80 $(BLOG_IMAGE_NAME)

container:
	docker build -t $(BLOG_IMAGE_NAME) .

serve-dev: container-dev
	docker run --rm -it -v `pwd`/tmp/logs:/mtail/logs -p 8080:80 $(BLOG_IMAGE_NAME)-dev

container-dev:
	docker build -f Dockerfile.dev -t $(BLOG_IMAGE_NAME)-dev .

mtail-container:
	docker build -t $(MTAIL_IMAGE_NAME) -f ./mtail/Dockerfile .

run-mtail: mtail-container
	docker run --rm -p 0.0.0.0:8081:8081 -v `pwd`/tmp/logs:/mtail/logs quay.io/brancz/blog-mtail:65f81d7 -progs=/mtail/progs/ -logs=/mtail/logs/access.log -port=8081
