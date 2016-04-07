
IMAGE := ramr/header-test
VERSION := v1


all:	build

build:	tlsconfig
	docker build -t $(IMAGE) ./
	docker tag $(IMAGE) $(IMAGE):$(VERSION)

run:
	@echo "  - Starting docker container for image $(IMAGE) ... "
	docker run -d -i -t $(IMAGE)

clean:
	@echo "  - Removing generated config files ... "
	@rm -f config/cert.pem config/key.pem config/req.csr
	@rm -f config/CA/cacert.pem config/CA/cakey.pem
	@rm -f config/CA/index.txt* config/CA/serial* config/CA/01.pem

	#  Shows errors for any containers running using those images.
	@echo "  - Removing docker images for $(IMAGE) ... "
	docker rmi $(IMAGE) || :
	docker rmi $(IMAGE):$(VERSION) || :


#  Internal targets.
tlsconfig:	cacertconfig certconfig

cacertconfig:	config/cacert.pem config/cakey.pem
certconfig:	config/cert.pem config/key.pem

config/cert.pem:	config/key.pem
config/cacert.pem:	config/cakey.pem

config/key.pem:
	./config/generate-tls-config.sh

config/cakey.pem:
	./config/generate-tls-config.sh

.PHONY: 	clean
