var fs    = require('fs');
var http  = require('http');
var https = require('https');
var util  = require('util');

/*!  Constants for insecure/secure ports.  */
var INSECURE_PORT = process.env.INSECURE_PORT || 8080;
var SECURE_PORT   = process.env.SECURE_PORT   || 8443;


function handler(req, res) {
   if ('/503' === req.url) {
     res.statusCode = 503;
     res.end('<pre>\ncustom 503 error page\n</pre>\n');
     return;
   }

   var data = [ ];
   for (var k in req.headers) {
     var v = new Buffer(req.headers[k], 'utf-8');
     data.push(util.format("  %s: %s", k, v) );
   }

   res.end(util.format('<pre>\n%s\n</pre>\n', data.join('\n')) );

}  /*  End of function  handler.  */


/**
 *   main(): create servers w/ that use to the handler to just dump headers.
 */
var insecureServer = http.createServer(handler);
insecureServer.listen(INSECURE_PORT, function() {
  console.log('server listening on port %d ... ', INSECURE_PORT);
});


var options = {
  key:  fs.readFileSync("config/tls.key"),
  cert: fs.readFileSync("config/tls.cert")
};

var secureServer = https.createServer(options, handler);
secureServer.listen(SECURE_PORT, function() {
  console.log('server listening on port %d ... ', SECURE_PORT);
});

