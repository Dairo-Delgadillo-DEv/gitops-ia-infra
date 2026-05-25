# Enterprise MLOps & Observability Infrastructure: Local Cloud-Native Cluster

This repository contains the enterprise-grade infrastructure implementation for microservices and Machine Learning workloads deployment. Built entirely with automated **Infrastructure as Code (IaC)**.

---

## 🏗️ System Architecture

The workflow implements a native **Zero-Trust GitOps pipeline** where cluster states are managed strictly through declarative code:

```text
  [ Cursor IDE ] ---> [ GitHub Repo ] <--- ( Listens & Pulls )
                             |
                             V
                       [ ArgoCD Engine ]
                             |
         +-------------------+-------------------+
         | (Auto-Sync)       | (Self-Heal)       | (Prune)
         V                   V                   V
  [ Namespace: argocd ] [ Namespace: monitoring ] [ Pod: Custom APIs ]
                             |
                             +---> [ Prometheus Server ] ---> ( Scrapes Metrics )
                             |
                             +---> [ Grafana Dashboards ] ---> ( Real-time Telemetry )
                             |
                             +---> [ Alertmanager Engine ] ---> [ Secure Telegram Channel ]
```

## 🛠️ Tech Stack & Core Standards

**Orchestration:** Kubernetes Local Cluster engineered via KinD (Kubernetes in Docker).

**Infrastructure as Code (IaC):** Terraform (Declarative provider orchestration and Helm-chart injections).

**Continuous Delivery (GitOps):** ArgoCD (Automated engine featuring automated sync, self-healing, and structural resource pruning).

**Observability Platform:** Prometheus stack combined with analytical data-source visualization via Grafana.

**Enterprise Alerting:** Native AlertmanagerConfig integration with webhook-driven delivery routing to custom chat recipients.

## 🚀 Key Architectural Implementations

### 1. Automated Infrastructure via Terraform
Manual infrastructure manipulation is fully replaced by HCL declarative blueprints. The cluster bootstrapper maps internal chart logic directly through Helm providers to provision components like monitoring stacks and observability solutions.

### 2. Autonomous GitOps Lifecycle
The cluster architecture runs under strict ArgoCD convergence policies:

- **Automated Sync:** Immediate application of manifests updated on the main repository branch.
- **Prune Resources:** Automatic execution of garbage collection logic within the cluster whenever a manifest gets removed from Git source.
- **Self-Heal Active Mode:** Real-time drift correction. If a cluster component or Pod gets altered manually, the GitOps engine tears down the variance and restores the exact state defined in Git.

### 3. Native Zero-Trust Secret Scoping
Production alert routing needs to handle sensitive bot tokens. To strictly protect access details and avoid credentials leakage, this design enforces Zero-Trust Token Enclosure:

- Webhook configurations utilize abstractions (AlertmanagerConfig).
- Cryptographic tokens are strictly isolated in-cluster inside native Kubernetes Secrets.
- Deployment definitions reference properties strictly via pointers (name & key), pulling live values at runtime without ever exposing credentials on public source control.

### 4. Telemetry Metrics Scoping
An end-to-end monitoring solution scrapes memory allocations, execution quotas, and CPU peaks dynamically. Cluster workloads are segregated into dedicated network slices (Namespaces), and administrative isolation ensures secure multi-tenant observability.

## 📊 Infrastructure Visual Telemetry (Grafana Dashboards)

Below are the live telemetry metrics captured directly from the internal cluster deployment. These dashboards illustrate resource mapping, node performance, and persistent data scraping under active production conditions.

### Active CPU Utilization Analysis
Continuous monitoring of CPU cycles allocation per component. The stacked area graph identifies the specific usage metrics for core stack components (Prometheus, Grafana, Node-Exporter) and validates resource efficiency.

### Persistent Memory Scoping (w/o cache)
End-to-end trace of persistent memory allocation across the namespace. This telemetry ensures stable thresholds for critical in-memory components (like Prometheus), preventing resource-driven OOMKiller events.

![Infrastructure Telemetry Dashboard](https://github.com/user-attachments/assets/93e2a7c2-b759-48d2-a549-252a32e4cfcf)

## 📈 System Operation & Telemetry Validation

### Simulating Production Alerts via Sockets

To evaluate routing accuracy, engineers can test pipeline triggers locally by mapping isolated microservices back to the host environment using port tunnels and testing hooks:

```bash
# Stabilize host-to-cluster network bridge
kubectl port-forward svc/kube-prometheus-stack-alertmanager -n monitoring 9999:9093 &

# Execute critical payload simulation to test secure routing
curl -H "Content-Type: application/json" \
  -d '[{"labels":{"alertname":"BunkerOpsWindowsNativo","severity":"critical","job":"mi-api"},"annotations":{"summary":"GitOps Pipeline Operational!","description":"Telemetry alerting channels fully operational"}}]' \
  http://localhost:9999/api/v1/alerts
```

---

**Developed by Dairo Delgadillo** — IT Infrastructure & MLOps Engineer Specialist.
