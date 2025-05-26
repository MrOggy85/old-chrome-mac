.PHONY build run

build:
	docker build \
		--platform=linux/amd64 \
		-t local/chrome:0.0.1 \
		.

run:
	docker run \
		-p 5900:5900 \
		--platform=linux/amd64 \
		--name chrome-local \
		-e VNC_SERVER_PASSWORD=password \
		--user apps \
		--privileged \
		local/chrome:0.0.1
