var http = require('http');
var util = require('util');

/*!  Constants for port.  */
var PORT = process.env.PORT || 8080;


/**
 *   main(): create a server w/ a request handler that just dumps headers.
 */
var server = http.createServer(function(req, res) {
   var data = [ ];
   for (var k in req.headers) {
     var v = new Buffer(req.headers[k], 'utf-8');
     data.push(util.format("  %s: %s", k, v) );
   }

   res.end(util.format('<pre>\n%s\n</pre>\n', data.join('\n')) );
});


server.listen(PORT, function() {
  console.log('server listening on port %d ... ', PORT);
});

