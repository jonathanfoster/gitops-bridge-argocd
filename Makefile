SHELL = /usr/bin/env bash -o pipefail
.SHELLFLAGS = -ec

KIND_CLUSTER_NAME ?= gitops-bridge-argocd

.PHONY: all
all: help

##@ Available Tasks:

.PHONY: argocd-bootstrap
argocd-bootstrap: ## Bootstrap ArgoCD
	kubectl create namespace argocd
	kubectl apply -n argocd -f https://raw.githubusercontent.com/argoproj/argo-cd/stable/manifests/install.yaml

.PHONY: argocd-password
argocd-password: ## Get ArgoCD password
	@kubectl -n argocd get secret argocd-initial-admin-secret -o jsonpath="{.data.password}" | base64 -d && echo

.PHONY: argocd-port-forward
argocd-port-forward: ## Port forward ArgoCD
	kubectl port-forward svc/argocd-server -n argocd 8080:443

.PHONY: help
help: ## Display this help
	@awk 'BEGIN {FS = ":.*##"; printf "\nUsage:\n  make <task>\n"} /^[a-zA-Z_0-9-]+:.*?##/ { printf "  %-15s %s\n", $$1, $$2 } /^##@/ { printf "\n%s\n", substr($$0, 5) } ' $(MAKEFILE_LIST)

.PHONY: install-toolchain
install-toolchain: ## Install toolchain
	brew install argocd

.PHONY: kind-create
kind-create: ## Create kind cluster
	kind create cluster --name=${KIND_CLUSTER_NAME}

.PHONY: kind-delete
kind-delete: ## Delete kind cluster
	kind delete cluster --name=${KIND_CLUSTER_NAME}
