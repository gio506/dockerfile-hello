# dockerfile-hello

Secure minimal Flask app with Docker best practices and CI smoke checks.

## What this repo is for

Use this repo to learn the smallest useful container workflow:

- build a Python app image
- run it locally with Docker
- expose health and version endpoints
- validate the app both directly in Python and through a running container
- understand how image scans fit into a simple pipeline

## Endpoints

- `GET /` -> hello response
- `GET /health` -> service health for probes
- `GET /version` -> app version from `APP_VERSION`

## Repo Map

- `app.py` - tiny Flask app and endpoints (`/`, `/health`, `/version`)
- `tests/test_app.py` - endpoint unit tests using Python `unittest`
- `requirements.txt` - Python dependencies
- `Dockerfile` - multi-stage build, non-root runtime, healthcheck
- `.dockerignore` - excludes unneeded local files from build context
- `Makefile` - developer commands: `build`, `run`, `unit-test`, `test`, `verify-local`, `stop`, `clean`
- `.github/workflows/pipeline.yml` - CI pipeline with structure, lint, tests, docs, build, smoke, and scan stages
- `CHEATSHEET.md` - day-to-day Docker command reference
- `FILES_EXPLAINED.md` - concise explanation of every tracked project file
- `README.md` - setup, run, CI, and troubleshooting

## Quick start

```bash
make build
make run
curl -fsS http://127.0.0.1:8000/
curl -fsS http://127.0.0.1:8000/health
curl -fsS http://127.0.0.1:8000/version
```

## Local test

```bash
make unit-test
make test
make verify-local
python -m unittest discover -s tests -p "test_*.py"
```

## Cleanup

```bash
make clean
```

## CI pipeline

The pipeline keeps these stages separate:

1. `structure-check`
2. `python-lint`
3. `unit-tests`
4. `markdown-lint`
5. `docker-build`
6. `container-smoke`
7. `trivy`

## Troubleshooting

- Port already in use: run `make clean` then retry.
- Docker daemon not running: start Docker and rerun `make build`.
- Trivy findings: review the report even when the scan does not block the build.

## Repository files

See `FILES_EXPLAINED.md` for the file-by-file guide.
