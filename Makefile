.PHONY: all build clean

IMAGE_REVISION=1.14

all: build

build:
	docker build -t ghcr.io/netxms/builder-rpm:$(IMAGE_REVISION) .
	docker tag ghcr.io/netxms/builder-rpm:$(IMAGE_REVISION) ghcr.io/netxms/builder-rpm:latest

clean:
	docker rmi -f ghcr.io/netxms/builder-rpm:$(IMAGE_REVISION)
	docker rmi -f ghcr.io/netxms/builder-rpm:latest
