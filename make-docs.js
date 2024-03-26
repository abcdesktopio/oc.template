/*
* Software Name : abcdesktop.io
* Version: 0.2
* SPDX-FileCopyrightText: Copyright (c) 2020-2021 Orange
* SPDX-License-Identifier: GPL-2.0-only
*
* This software is distributed under the GNU General Public License v2.0 only
* see the "license.txt" file for more details.
*
* Author: abcdesktop.io team
* Software description: cloud native desktop service
*/


/* eslint-disable no-console */
const fs = require('fs');
const path = require('path');
const childProcess = require('child_process');
const DOCKERREGISTRYPATH = 'abcdesktopio';
const HOSTEDURL = "https://raw.githubusercontent.com/abcdesktopio/oc.apps/main";
const RELEASE='3.0';

// function to encode file data to base64 encoded string
function base64Encode(file) {
  // read binary data
  const bitmap = fs.readFileSync(file);
  // convert binary data to base64 encoded string
  return bitmap.toString('base64');
}


// test function
function makedummy(e) {
  const tempname = "./dummy.md";
  const filename = tempname.toLowerCase();
  console.log( filename );
  var wstream = fs.createWriteStream(filename);
  wstream.write("dummy");
  wstream.end();
}


function writecmd( fd, cmd, type ) {
  fs.writeSync( fd, "\n");
  if (!type) type = ''; 
  fs.writeSync( fd, "``` " + type + "\n");
  fs.writeSync( fd, cmd + "\n" );
  fs.writeSync( fd, "```\n\n");
}


function getrelease( image ) {
  var release = undefined;
  var command = 'docker run --rm ' + DOCKERREGISTRYPATH + '/' + image;
  command += ' /bin/cat /etc/os-release';
  try {
    console.log(command);
    stdout = childProcess.execSync(command).toString();
    release = stdout;
  } catch (error) {
    console.error( `error in getrelease ${DOCKERREGISTRYPATH}/${image}`);
    // console.error( error );
    // error.status;  // 0 : successful exit, but here in exception it has to be greater than 0
    // error.message; // Holds the message you typically want.
    // error.stderr;  // Holds the stderr output. Use `.toString()`.
    // error.stdout;  // Holds the stdout output. Use `.toString()`.
 }
 console.log (release);
 return release;
}


const rootimages=[ 'debian', 'ubuntu', 'alpine', 'rockylinux' ];


function makedocumentation(imagename, imagebase, dockerfilename) {

  const imagebasenotag=imagebase.split(':')[0];
  const imagenamenotag=imagename.split(':')[0];
  const filename = imagenamenotag.toLowerCase() + '.md';

  console.log( 'createfile ' + filename );
  fd = fs.openSync(filename,'w');

  fs.writeSync( fd, `# ${imagenamenotag}\n`);

  var imagebasenotagnoprefix = imagebasenotag;
  if (imagebasenotagnoprefix.indexOf('/') != -1 ) {
    imagebasenotagnoprefix = imagebasenotagnoprefix.split('/')[1];
  }

  if (rootimages.includes( imagebasenotag ) ) {
    fs.writeSync( fd, `## from\n Docker official images [${imagebase}](https://hub.docker.com/_/${imagebasenotag})\n`);
  }
  else {
    fs.writeSync( fd, `## from\n inherit [${imagebase}](../${imagebasenotagnoprefix})\n`);
  }
  
  const release = getrelease(imagename);
  if (release) {
    fs.writeSync( fd,'## Container distribution release\n\n');
    writecmd( fd, release );
    fs.writeSync( fd, '\n');
  }
  fs.writeSync( fd, "\n" );
  fs.writeSync( fd, '## `DockerFile` source code\n');
  const dockefiledatadata = fs.readFileSync(dockerfilename,{encoding:'utf8', flag:'r'});
  writecmd( fd, dockefiledatadata );
  fs.writeSync( fd, "\n" );
  fs.writeSync( fd, "\n" );
	
  var date_time = new Date();
  fs.writeSync( fd, `> file ${filename} is created at ${date_time} by make-docs.js\n`);
	
  fs.closeSync( fd );
}

const args = process.argv.slice(2);

if ( args.length != 3) {
        console.error('make-docs.js invalid number of parameters ' + args.length );
	console.error('make-docs.js BASE_IMAGE BUILD_IMAGE DOCKERFILE');
	console.error('usage after the command docker build $(PROXY) $(NOCACHE) --build-arg BASE_IMAGE=$(1) -t abcdesktopio/$(2):$(TAG) -f $(3) .');
	process.exit(1);
}

var imagename = args[1];
if (imagename.indexOf('/') != -1 ) {
	imagename = imagename.split('/')[1];
}
	
var imagebase = args[0]
var dockerfilename = args[2];
console.log('imagename: ', imagename);
console.log('imagebase: ', imagebase);
console.log('dockerfilename: ', dockerfilename);
makedocumentation(imagename, imagebase, dockerfilename);
