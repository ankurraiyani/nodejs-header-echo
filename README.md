# nodejs-header-echo
Node.js header echo test service


Build Docker Image:
-------------------
Test service that echoes back the HTTP headers showcasing different routes supported on OpenShift.

To build the docker image, run ```make```:

    $  make   #  or make build


Usage with docker:
------------------
Ensure you build the docker image as mentioned above.
To run the test server with docker, run ```make run```:

    $  make run


Usage with OpenShift 3:
-----------------------
Ensure you build the docker image as mentioned above.
To run the test server with OpenShift 3, use:

    $  oc create -f openshift/dc.json
    $  oc create -f openshift/secure-service.json
    $  oc create -f openshift/insecure-service.json


Testing routes on OpenShift 3:
------------------------------
Ensure you build the docker image and add the header-test deployment config
and service to OpenShift 3 as mentioned in the build and usage sections
above.

    $  podname=$(oc get pods | grep header | awk '{ print $1 }')
    $  podip=$(oc get pods ${podname} -o json | grep "podIP" | cut -f 4 -d '"')
    $  curl -vvv -H "foo: bar" -H "Host: header.test"  http://${podip}:8080

    $  # Add the different flavor routes.
    $  for f in openshift/*route.json ; do
         oc create -f "$f";
         done

    $  oc get routes

    $  #  Check unsecured route (http only).
    $  curl --resolve unsecure.header.test:80:127.0.0.1 -vvv  \
            -H "test: http" -k http://unsecure.header.test

    $  #  Check edge terminated route with insecure allowed (http + https).
    $  curl --resolve allow-http.header.test:80:127.0.0.1 -vvv  \
            -H "test: allow-http" -k http://allow-http.header.test
    $  curl --resolve allow-http.header.test:443:127.0.0.1 -vvv  \
            -H "test: allow-https" -k https://allow-http.header.test

    $  #  Check edge terminated route with insecure disallowed (https only).
    $  #  This one should fail w/ a 503.
    $  curl --resolve no-http.header.test:80:127.0.0.1 -vvv  \
            -H "test: disallow-http" -k http://no-http.header.test
    $  #  This one should be ok.
    $  curl --resolve no-http.header.test:443:127.0.0.1 -vvv  \
            -H "test: disallow-https" -k https://no-http.header.test

    $  #  Check edge terminated route with insecure redirected
    $  #  (always https, http -> https).
    $  curl --resolve redirect-http.header.test:80:127.0.0.1 -vvv  \
            -H "test: redirect-http" -k http://redirect-http.header.test
    $  curl --resolve redirect-http.header.test:443:127.0.0.1 -vvv  \
            -H "test: redirect-https" -k https://redirect-http.header.test

    $  #  Check edge terminated route (https only).
    $  #  This one should fail w/ a 503.
    $ curl --resolve edge.header.test:80:127.0.0.1 -vvv  \
           -H "test: edge-http" -k http://edge.header.test
    $ curl --resolve edge.header.test:443:127.0.0.1 -vvv  \
           -H "test: edge-https" -k https://edge.header.test

    $  #  Check passthrough route (https only).
    $  #  This one should fail w/ a 503.
    $ curl --resolve passthrough.header.test:80:127.0.0.1 -vvv  \
           -H "test: passthrough-http" -k http://passthrough.header.test
    $ curl --resolve passthrough.header.test:443:127.0.0.1 -vvv  \
           -H "test: passthrough-http" -k https://passthrough.header.test

    $  #  Check re-encrypt route (https only).
    $  #  This one should fail w/ a 503.
    $ curl --resolve reencrypt.header.test:80:127.0.0.1 -vvv  \
           -H "test: reencrypt-http" -k http://reencrypt.header.test
    $ echo "need to add re-encrypt test w/ a known CA cert".

