#!/bin/bash

CFGDIR=$(cd -P -- "$(dirname "${BASH_SOURCE[0]}")" && pwd)
SUBJECT="/C=US/ST=CA/O=Security/OU=OpenShift3/CN=header.test"

echo "  - Generating 2048 bit key ... "
openssl genrsa -out "${CFGDIR}/key.pem" 2048

echo "  - Generating csr ... "
openssl req -new -nodes -sha256 -key "${CFGDIR}/key.pem"  \
            -out "${CFGDIR}/req.csr" -subj "${SUBJECT}"

echo "  - Generating cert ... "
#  7305 days is 20 years and if the started docker container is around at that
#  time, then it needs a new cert!! 
openssl x509 -req -in "${CFGDIR}/req.csr" -signkey "${CFGDIR}/key.pem"  \
             -days 7305 -out "${CFGDIR}/cert.pem"

