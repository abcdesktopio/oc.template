const fs = require('fs');

// Start open file
const content = fs.readFileSync( process.argv[2] );

// parse the applist.json file
var jsoncontent = JSON.parse(content);

// if jsoncontent is not an array 
// it may be a signel application json file description
// convert as an array
// if it is only one app
if ( !Array.isArray(jsoncontent) ) {
	jsoncontent = [ jsoncontent ];
}
res = JSON.stringify( jsoncontent );
output = res.replaceAll("\"", '\\"');
console.log( output );
