SHELL = /usr/bin/env bash -o pipefail
.SHELLFLAGS = -ec

CHART_PATH = charts/add-ons
CLUSTER_NAME ?= gitops-bridge

.PHONY: all
all: debug

.PHONY: cluster-create
cluster-create:
	kind create cluster --name=${CLUSTER_NAME}

.PHONY: kind-create
cluster-delete:
	kind delete cluster --name=${CLUSTER_NAME}

.PHONY: debug
debug:
	helm template add-ons ${CHART_PATH} --debug

.PHONY: deploy-local
deploy-local:
	kubectl apply -f clusters/local/add-ons.yaml

.PHONY: install-toolchain
install-toolchain:
	brew install argocd
	brew install helm

.PHONY: lint
lint:
	helm lint ${CHART_PATH}
