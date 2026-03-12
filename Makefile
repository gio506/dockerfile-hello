IMAGE_NAME ?= dockerfile-hello
CONTAINER_NAME ?= dockerfile-hello-app
PORT ?= 8000

.PHONY: build run test test-app test-docker clean

build:
	docker build -t $(IMAGE_NAME) .

run:
	docker run --rm -p $(PORT):8000 --name $(CONTAINER_NAME) $(IMAGE_NAME)

test: test-app test-docker

test-app:
	python -m unittest -v tests_app.py

test-docker:
	@if ! command -v docker >/dev/null 2>&1; then \
		echo "Docker CLI not found. Skipping container smoke tests."; \
	else \
		docker rm -f $(CONTAINER_NAME) >/dev/null 2>&1 || true; \
		docker build -t $(IMAGE_NAME) .; \
		docker run -d --rm -p $(PORT):8000 --name $(CONTAINER_NAME) $(IMAGE_NAME); \
		sleep 3; \
		curl -fsS http://127.0.0.1:$(PORT)/health; \
		curl -fsS http://127.0.0.1:$(PORT)/version; \
		docker rm -f $(CONTAINER_NAME) >/dev/null; \
	fi

clean:
	@docker rm -f $(CONTAINER_NAME) >/dev/null 2>&1 || true
	@docker image rm -f $(IMAGE_NAME) >/dev/null 2>&1 || true
