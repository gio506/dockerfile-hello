# Dockerfile Hello - Cheatsheet

## What each root file is for
- `app.py`: Flask app with hello and health endpoints.
- `requirements.txt`: Python package versions.
- `Dockerfile`: How to build and run the app image.
- `.dockerignore`: Keeps image builds fast by excluding unnecessary files.
- `Makefile`: One-command shortcuts for build/run/test/stop.
- `README.md`: Main project setup docs and command examples.
- `.github/workflows/pipeline.yml`: CI checks for image build + health test.

## Project quick start
- Build image: `make build`
- Run app: `make run`
- Health test: `make test`
- Stop local container: `make stop`

---

## Docker commands (core)
- Check Docker version: `docker version`
- Check Docker system info: `docker info`
- List all images: `docker images`
- List running containers: `docker ps`
- List all containers (running + stopped): `docker ps -a`
- List local volumes: `docker volume ls`
- List local networks: `docker network ls`

## Build commands
- Build default image: `docker build -t dockerfile-hello .`
- Build with custom tag: `docker build -t dockerfile-hello:v1 .`
- Build without cache: `docker build --no-cache -t dockerfile-hello:clean .`
- Build with explicit Dockerfile: `docker build -f Dockerfile -t dockerfile-hello .`

## Run commands
- Run in foreground: `docker run --rm -p 8000:8000 --name dockerfile-hello-app dockerfile-hello`
- Run in detached mode: `docker run -d --rm -p 8000:8000 --name dockerfile-hello-app dockerfile-hello`
- Set environment variable: `docker run --rm -e FLASK_ENV=production -p 8000:8000 dockerfile-hello`
- Override command: `docker run --rm dockerfile-hello python -V`

## Inspect + debug
- Show container logs: `docker logs dockerfile-hello-app`
- Follow logs live: `docker logs -f dockerfile-hello-app`
- Open shell in running container: `docker exec -it dockerfile-hello-app sh`
- Inspect container details: `docker inspect dockerfile-hello-app`
- Inspect image metadata: `docker inspect dockerfile-hello`
- Show resource usage: `docker stats`
- Show container port mappings: `docker port dockerfile-hello-app`

## Health and endpoint checks
- Root endpoint check: `curl -fsS http://127.0.0.1:8000/`
- Health endpoint check: `curl -fsS http://127.0.0.1:8000/health`
- Read health status from Docker inspect:
  - `docker inspect --format '{{json .State.Health}}' dockerfile-hello-app`

## Lifecycle management
- Stop container: `docker stop dockerfile-hello-app`
- Remove container: `docker rm dockerfile-hello-app`
- Force remove container: `docker rm -f dockerfile-hello-app`
- Remove image: `docker rmi dockerfile-hello`
- Remove dangling images: `docker image prune -f`
- Remove stopped containers: `docker container prune -f`
- Remove unused volumes: `docker volume prune -f`
- Remove unused networks: `docker network prune -f`
- Full cleanup (unused objects): `docker system prune -f`

## Save/load image (offline transfer)
- Save image to tar: `docker save -o dockerfile-hello.tar dockerfile-hello`
- Load image from tar: `docker load -i dockerfile-hello.tar`

## Optional registry commands
- Tag for registry: `docker tag dockerfile-hello your-registry/dockerfile-hello:latest`
- Push image: `docker push your-registry/dockerfile-hello:latest`
- Pull image: `docker pull your-registry/dockerfile-hello:latest`

## Makefile equivalents
- `make build` -> `docker build -t dockerfile-hello .`
- `make run` -> run container mapping `8000:8000`
- `make test` -> build + detached run + `curl /health` + cleanup
- `make stop` -> force-stop local container if running
