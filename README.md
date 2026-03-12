# dockerfile-hello

Secure minimal Flask app with Docker best practices and CI smoke checks.

## Endpoints
- `GET /` → hello response
- `GET /health` → service health for probes
- `GET /version` → app version (`APP_VERSION` env)

## Repo Map
- `app.py` - tiny Flask app and endpoints (`/`, `/health`, `/version`)
- `tests_app.py` - endpoint unit tests using Python `unittest`
- `requirements.txt` - Python dependencies
- `Dockerfile` - multi-stage build, non-root runtime, healthcheck
- `.dockerignore` - excludes unneeded local files from build context
- `Makefile` - developer commands: `build`, `run`, `test`, `test-app`, `test-docker`, `clean`
- `.github/workflows/pipeline.yml` - CI pipeline: lint+unit tests → build → smoke → optional Trivy
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

## Local Test
```bash
make test
```

`make test` is optimized for mixed environments:
- Always runs app unit tests.
- Runs Docker smoke test only when Docker CLI is available.

## Cleanup
```bash
make clean
```

## CI Stages
Pipeline (`.github/workflows/pipeline.yml`) has 4 stages:
1. **Lint and static checks** (including Dockerfile lint + unit tests)
2. **Build Docker image**
3. **Run container + curl smoke checks**
4. **Trivy security scan** (required check; non-blocking vulnerability report)

For merge readiness, configure branch protection on `main` and mark these checks as required:
- `Lint and static checks`
- `Build Docker image`
- `Container smoke test`
- `Trivy security scan`

## Best-practice references
- Docker: image-building best practices (multi-stage, small context, non-root where practical)
- Flask: production deployment guidance
- Trivy: container vulnerability scanning

## Troubleshooting
- **Port already in use**: run `make clean` then retry.
- **Docker daemon not running**: start Docker and rerun `make build`.
- **Local env has no Docker CLI**: `make test` will still run app unit tests and skip container smoke.
- **Trivy security findings**: the stage must pass, but it reports vulnerabilities without failing the build; review output and remediate high/critical findings.
