# FILES_EXPLAINED

- `.dockerignore` - keeps builds fast and avoids sending local junk to Docker context.
- `.github/workflows/pipeline.yml` - automated CI with lint, image build, smoke test, and optional Trivy scan.
- `.gitkeep` - placeholder to keep empty directories under version control if needed.
- `app.py` - Flask application entrypoint exposing `/`, `/health`, and `/version`.
- `CHEATSHEET.md` - quick Docker command cookbook for everyday tasks.
- `Dockerfile` - secure multi-stage image definition with non-root runtime user and healthcheck.
- `FILES_EXPLAINED.md` - this file; one-line purpose for each repository file.
- `Makefile` - local DX helpers (`build`, `run`, `test`, `clean`).
- `README.md` - primary docs: repo map, run instructions, CI, troubleshooting.
- `requirements.txt` - pinned Python package requirements.
