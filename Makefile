IMAGE_NAME ?= dockerfile-hello
CONTAINER_NAME ?= dockerfile-hello-app
PORT ?= 8000

.PHONY: build run test clean

build:
	docker build -t $(IMAGE_NAME) .

run:
	docker run --rm -p $(PORT):8000 --name $(CONTAINER_NAME) $(IMAGE_NAME)

test: build
	@docker rm -f $(CONTAINER_NAME) >/dev/null 2>&1 || true
	docker run -d --rm -p $(PORT):8000 --name $(CONTAINER_NAME) $(IMAGE_NAME)
	@sleep 2
	curl -fsS http://127.0.0.1:$(PORT)/health
	curl -fsS http://127.0.0.1:$(PORT)/version
	@docker rm -f $(CONTAINER_NAME) >/dev/null

clean:
	@docker rm -f $(CONTAINER_NAME) >/dev/null 2>&1 || true
	@docker image rm -f $(IMAGE_NAME) >/dev/null 2>&1 || true
