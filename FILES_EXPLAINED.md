# Files Explained

- `.dockerignore`
  - Keeps builds fast and avoids sending local junk to Docker context.
- `.github/workflows/pipeline.yml`
  - CI with structure checks, linting, unit tests, docs checks, image build,
    smoke tests, and Trivy scan.
- `.markdownlint.json`
  - Markdown lint configuration for repo docs.
- `app.py`
  - Flask application entrypoint exposing `/`, `/health`, and `/version`.
- `CHEATSHEET.md`
  - Quick Docker command cookbook for everyday tasks.
- `Dockerfile`
  - Secure multi-stage image definition with non-root runtime user and healthcheck.
- `FILES_EXPLAINED.md`
  - One-line purpose for each repository file.
- `Makefile`
  - Local helpers (`build`, `run`, `unit-test`, `test`, `verify-local`, `stop`, `clean`).
- `README.md`
  - Primary docs: repo map, run instructions, CI, troubleshooting.
- `requirements.txt`
  - Pinned Python package requirements.
- `tests/test_app.py`
  - Unit tests for HTTP endpoints.
