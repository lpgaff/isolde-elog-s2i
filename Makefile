
IMAGE_NAME = isolde-elog-almalinux9-with-sso

.PHONY: build
build:
	docker build -t $(IMAGE_NAME) .

