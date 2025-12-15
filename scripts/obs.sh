#!/usr/bin/env bash
set -euo pipefail

# Logs: Loki + Grafana

cd "$(dirname "$0")/.."

helm repo add grafana https://grafana.github.io/helm-charts >/dev/null
helm repo update >/dev/null

helm upgrade --install loki-stack grafana/loki-stack   -n observability --create-namespace   -f observability/loki-values.yaml

echo ""
echo "Grafana (logs) is in-cluster. To open locally:"
echo "  kubectl -n observability port-forward svc/loki-stack-grafana 3001:80"
echo "Then browse: http://localhost:3001"
echo "Login: admin / prom-operator (chart default)"
