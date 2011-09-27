var FFI = require("node-ffi");

var portaudio = new FFI.Library("./libportaudio", {
    "init": [ "int", [] ],
		"terminate": ["int",[]],
		"openstream_test": ["int",[]],
		"openstream":["pointer",["pointer"]]
});

var paCatch = function(err) {
	console.log(err);
	if (err != 0) 
		process.exit(err);
}

var initialize = function(){
	paCatch(portaudio.init());
}

var terminate = function(){
	paCatch(portaudio.terminate());
}

//initialize();
//var streamPtr = openstream(
paCatch(portaudio.openstream_test());
//terminate();
