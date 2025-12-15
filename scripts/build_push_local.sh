#!/usr/bin/env bash
set -euo pipefail

cd "$(dirname "$0")/.."

REGISTRY="${1:-localhost:5001}"
TAG="${2:-local}"

IMAGE="$REGISTRY/tiny-web:$TAG"

docker build -t "$IMAGE" ./app
docker push "$IMAGE"

echo "$IMAGE"
