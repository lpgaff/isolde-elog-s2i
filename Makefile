
IMAGE_NAME = isolde-elog-centos8

.PHONY: build
build:
	docker build -t $(IMAGE_NAME) .

