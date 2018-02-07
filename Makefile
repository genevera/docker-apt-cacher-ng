TAG?=quay.io/genevera/apt-cacher-ng

all: build push

build: ## build the image
	@docker build --tag=$(TAG) .

push: ## push the image
	@docker push $(TAG)
