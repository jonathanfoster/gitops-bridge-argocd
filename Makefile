SHELL = /usr/bin/env bash -o pipefail
.SHELLFLAGS = -ec
CHART_PATH = charts/add-ons

.PHONY: all
all: debug

.PHONY: debug
debug:
	helm template add-ons ${CHART_PATH} --debug

.PHONY: deploy-local
deploy-local:
	kubectl apply -f clusters/local/add-ons.yaml

.PHONY: install-toolchain
install-toolchain:
	brew install helm

.PHONY: lint
lint:
	helm lint ${CHART_PATH}
