# nodejs-header-echo
Node.js header echo test service


Info:
-----
Test service that echoes back the HTTP headers showcasing different routes supported on OpenShift.

To build the docker image, run ```make```:
    $  make     #  or make build
  
  
Usage: 
First make sure you build the docker image as mentioned above.

To run the test server with docker, run ```make run```: 
    $  make run 
    
To run it with OpenShift 3, use:
    $  oc create -f _openshift/dc.json
    $  oc create -f _openshift/service.json

