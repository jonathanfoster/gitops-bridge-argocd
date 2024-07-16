# GitOps Bridge

## Getting Started

### 1. Create Local Cluster

```bash
kind create cluster --name=gitops-bridge
```

### 2. Install Argo CD

```bash
kubectl create namespace argocd
kubectl apply -n argocd -f https://raw.githubusercontent.com/argoproj/argo-cd/stable/manifests/install.yaml
```

### 3. Install Add-Ons

```bash
kubectl apply -n argocd -f clusters/local/add-ons.yaml
```
