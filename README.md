# dockerfile-hello

Minimal Flask app packaged with Docker (production-style runtime via Gunicorn).

## Project tree

```text
.
├── .dockerignore              # excludes local/dev files from Docker build context
├── .github/workflows/ci.yml   # CI pipeline: build image, run container, curl /health
├── Dockerfile                 # Python image, non-root runtime, Gunicorn, healthcheck
├── Makefile                   # helper targets: build, run, test, stop
├── README.md                  # setup and usage instructions
├── app.py                     # Flask app with / and /health endpoints
└── requirements.txt           # pinned Python dependencies
```

## Prerequisites

- Docker
- curl
- make

## Build and run locally

```bash
make build
make run
```

Open `http://localhost:5000/` for hello message.

## Test health endpoint

```bash
make test
```

Expected response:

```json
{"status":"ok"}
```

## Stop container

```bash
make stop
```

## Docker cheat sheet (popular commands)

```bash
# Images
docker images                              # list local images
docker build -t dockerfile-hello:latest . # build image from Dockerfile
docker rmi dockerfile-hello:latest         # remove image

# Containers
docker ps                                  # list running containers
docker ps -a                               # list all containers
docker run -d --name hello -p 5000:5000 dockerfile-hello:latest  # run container
docker logs -f hello                       # stream container logs
docker exec -it hello sh                   # open shell inside container
docker stop hello                          # stop running container
docker rm hello                            # remove container

# Cleanup
docker system df                           # show Docker disk usage
docker system prune -f                     # remove unused data
```

## Notes on best practices used

- Uses a non-root container user.
- Uses Gunicorn instead of Flask dev server for runtime.
- Includes container `HEALTHCHECK` and CI health probe.
- Keeps dependencies pinned in `requirements.txt`.
