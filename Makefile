image_tag := povilasb/demo-quic-server

image:
	docker build -t $(image_tag) .
.PHONY: image

container:
	docker run --name demo-quic-server -t $(image_tag)
.PHONY: container
