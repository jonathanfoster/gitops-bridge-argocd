# GitOps Bridge Argo CD

## Getting Started

### 1. Create Local Clusters

```bash
kind create cluster --name=gitops-bridge-argocd
```

### 2. Install Argo CD

```bash
kubectl create namespace argocd
kubectl apply -n argocd -f https://raw.githubusercontent.com/argoproj/argo-cd/stable/manifests/install.yaml
```

### 3. Create Secrets

```bash
kubectl create namespace monitoring
```

```bash
kubectl create secret generic -n monitoring grafana-cloud-logs \
--from-literal=username=$GRAFANA_LOGS_USERNAME \
--from-literal=password=$GRAFANA_TOKEN
```

```bash
kubectl create secret generic -n monitoring grafana-cloud-metrics \
--from-literal=username=$GRAFANA_METRICS_USERNAME \
--from-literal=password=$GRAFANA_TOKEN
```

```bash
kubectl create secret generic -n monitoring grafana-cloud-traces \
--from-literal=username=$GRAFANA_TRACES_USERNAME \
--from-literal=password=$GRAFANA_TOKEN
```

### 3. Install Apps

```bash
kubectl apply -n argocd -f clusters/development/addons.yaml
kubectl apply -n argocd -f clusters/development/monitoring.yaml
```

## Accessing the Argo CD Server

### 1. Expose the Argo CD Server

```bash
kubectl port-forward svc/argocd-server -n argocd 8080:443
```

The API server can be accessed at <https://localhost:8080>.

### 2. Login to the Argo CD Server

Get the admin password.

```bash
kubectl -n argocd get secret argocd-initial-admin-secret -o jsonpath="{.data.password}" | base64 -d && echo
```

## Repository Structure

```bash
gitops-bridge-argocd/
├── bootstrap/                  # ArgoCD bootstrap manifests
│   ├── base/                   # Base ArgoCD installation
│   └── overlays/               # Environment-specific ArgoCD configs
├── clusters/                   # Cluster-specific configurations
│   ├── development/            # Development cluster configs
│   │   ├── addons.yaml         # Cluster addons (cert-manager, etc.)
│   │   ├── apps.yaml           # Application definitions
│   │   └── kustomization.yaml  # Kustomize config for the cluster
│   └── production/             # Production cluster configs
│       ├── addons.yaml
│       ├── apps.yaml
│       └── kustomization.yaml
├── apps/                       # Application definitions
│   ├── cert-manager/           # cert-manager configuration
│   │   ├── base/               # Base configuration
│   │   └── overlays/           # Environment-specific configs
│   ├── monitoring/             # Monitoring stack (Prometheus, Grafana)
│   └── other-apps/             # Other applications
├── charts/                     # Helm charts (if you're using Helm)
├── environments/               # Environment-specific values
│   ├── development/
│   └── production/
└── Makefile                    # Build and deployment automation
```
