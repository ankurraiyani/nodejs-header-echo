
IMAGE := ramr/header-test


all:	build

build:	tlsconfig
	docker build -t $(IMAGE) ./

run:
	docker run -d -i -t $(IMAGE)

clean:
	@echo "  - Removing generated config files ... "
	@rm -f config/cert.pem config/key.pem config/req.csr

	#  Shows errors for any containers running using that image.
	@echo "  - Removing docker image for $(IMAGE) ... "
	docker rmi $(IMAGE) || :


#  Internal targets.
tlsconfig:	config/cert.pem config/key.pem

config/cert.pem:	config/key.pem

config/key.pem:
	./config/generate-tls-config.sh

.PHONY: 	clean
