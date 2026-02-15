# Dockerfile Hello - Cheatsheet

## What each root file is for
- `app.py`: Flask app with hello and health endpoints.
- `requirements.txt`: Python package versions.
- `Dockerfile`: How to build and run the app image.
- `.dockerignore`: Keeps image builds fast by excluding unnecessary files.
- `Makefile`: One-command shortcuts for build/run/test/stop.
- `README.md`: Main project setup docs and command examples.
- `.github/workflows/pipeline.yml`: CI checks for image build + health test.

## Fast commands
- Build image: `make build`
- Run app: `make run`
- Health test: `make test`
- Stop local container: `make stop`
