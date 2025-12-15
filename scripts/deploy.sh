#!/usr/bin/env bash
set -euo pipefail

cd "$(dirname "$0")/.."

REGISTRY="${1:-localhost:5001}"
TAG="${2:-local}"

helm upgrade --install tiny-web ./deploy/helm/tiny-web   --namespace demo --create-namespace   --set image.repository="$REGISTRY/tiny-web"   --set image.tag="$TAG"
