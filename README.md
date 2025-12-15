
````md
# devops-k8s-node-app

This project shows a simple end-to-end DevOps setup using a small Node.js app.

The goal is not to build a complex application, but to demonstrate:
- local infrastructure setup
- containerization
- Kubernetes deployment
- CI/CD
- basic observability (logs and metrics)

---

## What this project contains

- A Node.js web application
- Docker image build
- Local Kubernetes cluster using KinD
- Local infrastructure created with Terraform
- Application deployment using Helm
- CI pipeline using GitHub Actions
- Logs via Loki
- Metrics via Prometheus and Grafana

---

## Application overview

The Node.js app exposes:
- `/` – simple response
- `/healthz` – health check
- `/metrics` – Prometheus metrics endpoint

The `/metrics` endpoint exposes default runtime and process metrics.
No custom business metrics are added intentionally to keep the app simple.

---

## Local infrastructure (Terraform)

Terraform is used **only for local development**.

It creates:
- A local Docker registry
- A KinD Kubernetes cluster
- Network wiring so the cluster can pull images from the local registry

To create the local infrastructure:

```bash
make up
````

To delete everything:

```bash
make down
```

---

## Build and deploy locally

### Build the Docker image

```bash
make build
```

### Deploy to Kubernetes

```bash
make deploy
```

Check resources:

```bash
kubectl -n demo get all
```

---

## Access the application

Port-forward the service:

```bash
make port-forward
```

Open in browser:

```
http://localhost:8080
```

Or test with curl:

```bash
curl http://localhost:8080/
curl http://localhost:8080/healthz
curl http://localhost:8080/metrics
```

---

## Logs

### Kubernetes logs

```bash
kubectl -n demo logs -l app=tiny-web --tail=50
```

### Centralized logs (Loki + Grafana)

Install Loki locally:

```bash
make obs
```

Access Grafana:

```bash
kubectl -n observability port-forward svc/loki-stack-grafana 3001:80
```

Open:

```
http://localhost:3001
```

Logs can be queried using labels like:

```
{app="tiny-web"}
```

---

## Metrics (Prometheus + Grafana)

Install Prometheus stack locally:

```bash
make metrics
```

Access Grafana:

```bash
kubectl -n monitoring port-forward svc/monitoring-grafana 4000:80
```

Open:

```
http://localhost:4000
```

Prometheus metrics are available via the `/metrics` endpoint.
Example queries:

```promql
up
process_cpu_seconds_total
process_resident_memory_bytes
```

These metrics confirm that the application is running and being scraped.

---

## CI/CD (GitHub Actions)

The CI pipeline runs on every push and pull request.

It performs:

1. Dependency install and tests
2. Docker image build
3. Push image to GitHub Container Registry (GHCR)
4. Create a KinD cluster inside the CI runner
5. Install Prometheus stack
6. Deploy the app using Helm
7. Smoke tests for `/healthz` and `/metrics`

CI validates that the app can be built, deployed, and observed automatically.

---

## Project structure

```
app/                    # Node.js app
infra/terraform/        # Terraform for local infra
deploy/helm/tiny-web/   # Helm chart
scripts/                # Helper scripts
.github/workflows/      # CI pipeline
Makefile
```

---

## Notes

* Terraform is used for local infrastructure only.
* CI uses ephemeral infrastructure created inside the GitHub runner.
* Metrics shown are runtime/process metrics, not business metrics.
* The setup is intentionally simple and easy to understand.

```

---


