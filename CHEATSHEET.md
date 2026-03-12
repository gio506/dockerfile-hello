# Dockerfile Hello - Cheatsheet

## Quick project commands
- Build image: `make build`
- Run app: `make run`
- Full test suite: `make test`
- App-only tests: `make test-app`
- Docker smoke tests only: `make test-docker`
- Cleanup container/image: `make clean`

## Core Docker commands
- `docker version`
- `docker info`
- `docker images`
- `docker ps`
- `docker ps -a`

## Build and run manually
- `docker build -t dockerfile-hello .`
- `docker run --rm -p 8000:8000 --name dockerfile-hello-app dockerfile-hello`
- `docker run -d --rm -p 8000:8000 --name dockerfile-hello-app dockerfile-hello`

## Health + version checks
- `curl -fsS http://127.0.0.1:8000/health`
- `curl -fsS http://127.0.0.1:8000/version`
- `docker inspect --format '{{json .State.Health}}' dockerfile-hello-app`

## Debug and cleanup
- `docker logs dockerfile-hello-app`
- `docker exec -it dockerfile-hello-app sh`
- `docker rm -f dockerfile-hello-app`
- `docker rmi dockerfile-hello`
- `docker system prune -f`

## Optional image scan
- `docker run --rm -v /var/run/docker.sock:/var/run/docker.sock aquasec/trivy:latest image dockerfile-hello`
