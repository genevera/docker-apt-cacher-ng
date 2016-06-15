all: build

build:
	@docker build --tag=quay.io/genevera/apt-cacher-ng .
