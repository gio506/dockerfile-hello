#!/usr/bin/env bash
# Purpose: Build the Docker image locally with proper tagging
# Usage: bash scripts/build-local.sh [tag]

set -euo pipefail

IMAGE_NAME="dockerfile-hello"
TAG="${1:-local}"
GIT_SHA="$(git rev-parse --short HEAD 2>/dev/null || echo 'unknown')"
BUILD_DATE="$(date -u +'%Y-%m-%dT%H:%M:%SZ')"

echo "Building $IMAGE_NAME:$TAG (sha=$GIT_SHA)"

docker build \
  --build-arg BUILD_DATE="$BUILD_DATE" \
  --build-arg VCS_REF="$GIT_SHA" \
  -t "$IMAGE_NAME:$TAG" \
  -t "$IMAGE_NAME:$GIT_SHA" \
  .

echo ""
echo "Built successfully:"
echo "  - $IMAGE_NAME:$TAG"
echo "  - $IMAGE_NAME:$GIT_SHA"
echo ""
echo "To run:"
echo "  docker run --rm -p 8080:8080 $IMAGE_NAME:$TAG"
echo ""
echo "To scan for vulnerabilities:"
echo "  docker run --rm -v /var/run/docker.sock:/var/run/docker.sock \\"
echo "    aquasec/trivy:latest image --severity HIGH,CRITICAL $IMAGE_NAME:$TAG"
