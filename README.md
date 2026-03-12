# dockerfile-hello

Secure minimal Flask app with Docker best practices and CI smoke checks.

## Endpoints
- `GET /` → hello response
- `GET /health` → service health for probes
- `GET /version` → app version (`APP_VERSION` env)

## Repo Map
- `app.py` - tiny Flask app and endpoints (`/`, `/health`, `/version`)
- `requirements.txt` - Python dependencies
- `Dockerfile` - multi-stage build, non-root runtime, healthcheck
- `.dockerignore` - excludes unneeded local files from build context
- `Makefile` - developer commands: `build`, `run`, `test`, `clean`
- `.github/workflows/pipeline.yml` - CI pipeline: lint → build → smoke → optional Trivy
- `CHEATSHEET.md` - day-to-day Docker command reference
- `FILES_EXPLAINED.md` - concise explanation of every tracked project file
- `README.md` - setup, run, CI, and troubleshooting

## Local Run
```bash
make build
make run
```

In another terminal:
```bash
curl -fsS http://127.0.0.1:8000/health
curl -fsS http://127.0.0.1:8000/version
```

## Local Smoke Test
```bash
make test
```

## Cleanup
```bash
make clean
```

## CI Stages
Pipeline (`.github/workflows/pipeline.yml`) has 4 stages:
1. **Lint and static checks**
2. **Build Docker image**
3. **Run container + curl smoke checks**
4. **Optional Trivy scan** (soft-fail)

To enforce merge quality in GitHub, set these checks as **required** in branch protection for `main`.

## Troubleshooting
- **Port already in use**: run `make clean` then retry.
- **Docker daemon not running**: start Docker Desktop/daemon and rerun `make build`.
- **Health check fails immediately**: wait a few seconds and retry `make test`.
- **Trivy stage warns/fails**: scan is soft-fail by design; review output and fix high/critical findings.
