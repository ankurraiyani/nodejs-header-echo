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

    $  oc create -f _openshift/dc.json
    $  oc create -f _openshift/service.json


Testing routes on OpenShift 3:
------------------------------
Ensure you build the docker image and add the header-test deployment config
and service to OpenShift 3 as mentioned in the build and usage sections
above.

    $  podname=$(oc get pods | grep header | awk '{ print $1 })
    $  podip=$(oc get pods ${podname} -o json | grep "podIP" | cut -f 4 -d '"')
    $  curl -vvv -H "foo: bar" -H "Host: header.test"  http://${podip}:8080

    $  oc create -f openshift/unsecured-route.json
    $  oc create -f openshift/edge-secured-route.json
    $  oc create -f openshift/edge-secured-redirect-route.json 
    $  oc create -f openshift/edge-secured-allow-http-route.json 
    $  oc create -f openshift/edge-secured-no-http-route.json

