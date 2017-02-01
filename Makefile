
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

certconfig:	config/tls.crt config/tls.key
cacertconfig:	config/CA/cacert.pem config/CA/cakey.pem

config/tls.crt:	config/cert.pem
	(cd config; ln -s cert.pem tls.crt)

config/tls.key:	config/key.pem
	(cd config; ln -s key.pem tls.key)

config/cert.pem:	config/key.pem

config/key.pem:
	./config/generate-tls-config.sh


config/CA/cacert.pem:	config/CA/cakey.pem

config/CA/cakey.pem:
	./config/generate-tls-config.sh

.PHONY: 	clean
