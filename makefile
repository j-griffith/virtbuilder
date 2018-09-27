build:
	docker build -t quay.io/fabiand/virtbuilder .

run:
	docker run -it quay.io/fabiand/virtbuilder fedora-28 6G
