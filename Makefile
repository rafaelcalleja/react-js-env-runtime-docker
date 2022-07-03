IMAGE_NAME := rafaelcalleja/react-app-hello-world
IMAGE_TAG ?= latest

.PHONY: default
default: build

.PHONY: build
build:
	@docker build -t $(IMAGE_NAME):$(IMAGE_TAG) .

