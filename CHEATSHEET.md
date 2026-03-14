# Dockerfile Hello - Cheatsheet

## What each root file is for

- `app.py`: Flask app with hello, health, and version endpoints.
- `requirements.txt`: Python package versions.
- `Dockerfile`: How to build and run the app image.
- `.dockerignore`: Keeps image builds fast by excluding unnecessary files.
- `Makefile`: One-command shortcuts for build, run, unit-test, smoke test, cleanup.
- `README.md`: Main project setup docs and command examples.
- `.github/workflows/pipeline.yml`: CI from structure checks through Trivy scan.
- `.markdownlint.json`: Markdown lint settings.
- `FILES_EXPLAINED.md`: File-by-file explanation for fast repo review.
- `tests/test_app.py`: Direct app tests without Docker.

## Quick project commands

- Build image: `make build`
- Run app: `make run`
- Run Python tests: `make unit-test`
- Health test: `make test`
- Run full local verification: `make verify-local`
- Cleanup: `make clean`

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

## Health and version checks

- `curl -fsS http://127.0.0.1:8000/`
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
