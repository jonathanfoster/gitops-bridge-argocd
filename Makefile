SHELL = /usr/bin/env bash -o pipefail
.SHELLFLAGS = -ec

CLUSTER_NAME ?= gitops-bridge-argocd

.PHONY: all
all: help

.PHONY: argocd-password
argocd-password: ## Get ArgoCD admin password
	kubectl -n argocd get secret argocd-initial-admin-secret -o jsonpath="{.data.password}" | base64 -d && echo

.PHONY: argocd-server
argocd-server: ## Start port-forward for ArgoCD server
	kubectl port-forward svc/argocd-server -n argocd 8080:443

.PHONY: bootstrap-argocd
bootstrap-argocd: ## Bootstrap cluster with ArgoCD
	helm repo add argo https://argoproj.github.io/argo-helm
	helm install argocd argo/argo-cd -n argocd --create-namespace

.PHONY: bootstrap-development
bootstrap-development: ## Bootstrap cluster with development apps
	kubectl apply -f bootstrap/development.yaml

.PHONY: help
help: ## Display this help message
	@echo "Usage: make [target]"
	@echo ""
	@echo "Targets:"
	@awk 'BEGIN {FS = ":.*?## "} /^[a-zA-Z_-]+:.*?## / {printf "  %-25s %s\n", $$1, $$2}' $(MAKEFILE_LIST)

.PHONY: kind-create
kind-create: ## Create kind clusters
	kind create cluster --name=${CLUSTER_NAME}-dev

.PHONY: kind-delete
kind-delete: ## Delete kind clusters
	kind delete cluster --name=${CLUSTER_NAME}-dev

.PHONY: install-toolchain
install-toolchain: ## Install required tools (argocd, helm, yamllint)
	brew install argocd
	brew install helm
	brew install yamllint

.PHONY: lint
lint: lint-yaml ## Run all linters

.PHONY: lint-yaml
lint-yaml: ## Lint YAML files
	yamllint .
