#!/usr/bin/env bash
set -euo pipefail

cd "$(dirname "$0")/.."

./scripts/requirements.sh

cd infra/terraform
terraform init -upgrade
terraform apply -auto-approve
echo ""
echo "Cluster ready."
