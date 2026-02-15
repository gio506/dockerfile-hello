# dockerfile-hello

A minimal Flask app containerized with Docker.

## Endpoints
- `GET /` → hello response
- `GET /health` → health status for checks

## Project tree
```text
.
├── .dockerignore              # Excludes unnecessary files from docker build context
├── .github/workflows/
│   └── pipeline.yml           # 2-stage CI: quality checks, then Docker build + health check
├── app.py                     # Minimal Flask app with / and /health endpoints
├── Dockerfile                 # Multi-stage image (builder + runtime) with healthcheck
├── Makefile                   # Local commands: build, run, test, stop
├── README.md                  # Setup and usage instructions
├── requirements.txt           # Python dependency list
└── CHEATSHEET.md              # Quick reference for what each file/command is for
```

## Build and run
```bash
make build
make run
```

Then open another terminal and test:
```bash
curl http://127.0.0.1:8000/
curl http://127.0.0.1:8000/health
```

## Local test
```bash
make test
```

## CI pipeline
The pipeline is in `.github/workflows/pipeline.yml` and has two jobs (stages):
1. **Quality checks**: Python syntax validation and endpoint smoke tests via Flask test client
2. **Docker**: Build image, run container, and verify `http://127.0.0.1:8000/health` with retry logic
