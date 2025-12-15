#!/usr/bin/env bash
set -euo pipefail

cd "$(dirname "$0")/.."
cd infra/terraform
terraform destroy -auto-approve
