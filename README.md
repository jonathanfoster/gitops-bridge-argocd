# GitOps Bridge ArgoCD

## Getting Started

### 1. Create Local Cluster

To create a local cluster:

```bash
kind create cluster --name=gitops-bridge-argocd
```

### 2. Install Argo CD

To install Argo CD:

```bash
kubectl create namespace argocd
kubectl apply -n argocd -f https://raw.githubusercontent.com/argoproj/argo-cd/stable/manifests/install.yaml
```

### 3. Retrieve Argo CD password

To retrieve the Argo CD password:

```bash
kubectl -n argocd get secret argocd-initial-admin-secret -o jsonpath="{.data.password}" | base64 -d && echo
```

### 4. Expose the Argo CD server

To expose the Argo CD server:

```bash
kubectl port-forward svc/argocd-server -n argocd 8080:443
```

The server can be accessed at <https://localhost:8080>.
