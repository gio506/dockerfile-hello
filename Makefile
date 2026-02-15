IMAGE_NAME ?= dockerfile-hello
CONTAINER_NAME ?= dockerfile-hello-app
PORT ?= 5000

.PHONY: build run test stop

build:
	docker build -t $(IMAGE_NAME):latest .

run:
	docker rm -f $(CONTAINER_NAME) >/dev/null 2>&1 || true
	docker run -d --name $(CONTAINER_NAME) -p $(PORT):5000 $(IMAGE_NAME):latest

test:
	for i in 1 2 3 4 5 6 7 8 9 10; do \
		curl -fsS http://localhost:$(PORT)/health && exit 0; \
		sleep 1; \
	done; \
	exit 1

stop:
	docker rm -f $(CONTAINER_NAME) >/dev/null 2>&1 || true
