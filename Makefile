IMAGE_NAME = quay.io/cermakm/jupyter-notebook-s2i

.PHONY: build
build:
	docker build -t $(IMAGE_NAME) .

.PHONY: build-candidate
build-candidate:
	docker build -t $(IMAGE_NAME)-candidate .

.PHONY: test
test: build-candidate
	IMAGE_NAME=$(IMAGE_NAME)-candidate test/s2i/run
