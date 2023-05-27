const fs = require('fs');
// Start open file
const content = fs.readFileSync( process.argv[2] );
// parse the applist.json file
var jsoncontent = JSON.parse(content);
res = JSON.stringify( jsoncontent );
console.log( res );
