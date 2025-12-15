#!/usr/bin/env bash
set -euo pipefail

# Metrics: Prometheus + Grafana (kube-prometheus-stack)

helm repo add prometheus-community https://prometheus-community.github.io/helm-charts >/dev/null
helm repo update >/dev/null

helm upgrade --install monitoring prometheus-community/kube-prometheus-stack   -n monitoring --create-namespace

echo ""
echo "Prometheus/Grafana is in-cluster."
echo "Grafana UI:"
echo "  kubectl -n monitoring port-forward svc/monitoring-grafana 3002:80"
echo "Then browse: http://localhost:3002"
