.PHONY: all clean build-epel8 build-epel9 build-epel10 build-fedora42 build-fedora43

REGISTRY = ghcr.io/netxms/builder-rpm

all: build-epel8 build-epel9 build-epel10 build-fedora42 build-fedora43

build-epel8:
	docker build --build-arg BASE_IMAGE=oraclelinux:8 --build-arg DISTRO_TYPE=epel --build-arg DISTRO_VERSION=8 -t $(REGISTRY):epel8 .

build-epel9:
	docker build --build-arg BASE_IMAGE=oraclelinux:9 --build-arg DISTRO_TYPE=epel --build-arg DISTRO_VERSION=9 -t $(REGISTRY):epel9 .

build-epel10:
	docker build --build-arg BASE_IMAGE=oraclelinux:10 --build-arg DISTRO_TYPE=epel --build-arg DISTRO_VERSION=10 -t $(REGISTRY):epel10 .

build-fedora42:
	docker build --build-arg BASE_IMAGE=fedora:42 --build-arg DISTRO_TYPE=fedora --build-arg DISTRO_VERSION=42 -t $(REGISTRY):fedora42 .

build-fedora43:
	docker build --build-arg BASE_IMAGE=fedora:43 --build-arg DISTRO_TYPE=fedora --build-arg DISTRO_VERSION=43 -t $(REGISTRY):fedora43 .

clean:
	docker rmi -f $(REGISTRY):epel8 $(REGISTRY):epel9 $(REGISTRY):epel10 $(REGISTRY):fedora42 $(REGISTRY):fedora43
