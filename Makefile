IMAGE_NAME ?= dockerfile-hello
CONTAINER_NAME ?= dockerfile-hello-app
PORT ?= 8000

.PHONY: build run unit-test test verify-local stop clean

build:
	docker build -t $(IMAGE_NAME) .

run:
	docker run --rm -e APP_VERSION=local -p $(PORT):8000 --name $(CONTAINER_NAME) $(IMAGE_NAME)

unit-test:
	python -m unittest discover -s tests -p "test_*.py"

test: build
	@docker rm -f $(CONTAINER_NAME) >/dev/null 2>&1 || true
	docker run -d --rm -e APP_VERSION=local -p $(PORT):8000 --name $(CONTAINER_NAME) $(IMAGE_NAME)
	@sleep 2
	curl -fsS http://127.0.0.1:$(PORT)/health
	curl -fsS http://127.0.0.1:$(PORT)/version
	@docker rm -f $(CONTAINER_NAME) >/dev/null

verify-local: unit-test test

stop:
	@docker rm -f $(CONTAINER_NAME) >/dev/null 2>&1 || true

clean: stop
	@docker image rm -f $(IMAGE_NAME) >/dev/null 2>&1 || true
