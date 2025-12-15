#!/usr/bin/env bash
set -e

need() {
  command -v "$1" >/dev/null 2>&1 || {
    echo "Missing: $1"
    exit 1
  }
}

need docker
need terraform
need kind
need kubectl
need helm

echo "ok"
