# based on https://github.com/jvoorhis/ruby-portaudio/blob/master/lib/portaudio.rb
ffi = require 'node-ffi'
portaudio = new ffi.Library "libportaudio"

# types
PA_ERROR = 'int'
PA_DEVICE_INDEX = 'int'
PA_HOST_API_TYPE_ID = 'int'
PA_HOST_API_INDEX = 'int'
PA_TIME = 'double'
PA_SAMPLE_FORMAT = 'ulong'
PA_SAMPLE_FORMAT_MAP = 0
PA_STREAM_FLAGS = 'ulong'
PA_STREAM_CALLBACK_FLAGS = 'ulong'
PA_STREAM_CALLBACK_RESULT = 'int'
PA_STREAM_CALLBACK = 'pointer'
PA_STREAM_FINISHED_CALLBACK = 'pointer'

# constants
PA_NO_ERROR = 0
PA_NO_DEVICE = Math.pow(2,ffi.sizeOf('long')) - 1
PA_SAMPLE_FORMAT_MAP = {
	'float32': 0x00000001
	'int32':   0x00000002
	'int24':   0x00000004
	'int16':   0x00000008
  'int8':    0x00000010
  'uint8':   0x00000020
  'custom':  0x00010000
}
PA_NON_INTERLEAVED = 0x80000000
PA_FORMAT_IS_SUPPORTED = 0
PA_FRAMES_PER_BUFFER_UNSPECIFIED = 0
PA_NO_FLAG = 0
PA_CLIP_OFF = 0x00000001
PA_DITHER_OFF = 0x00000002
PA_NEVER_DROP_INPUT = 0x00000004
PA_PRIME_OUTPUT_BUFFERS_USING_STREAM_CALLBACK = 0x00000008
PA_PLATFORM_SPECIFIC_FLAGS = 0xFFFF0000
PA_INPUT_UNDERFLOW = 0x00000001
PA_INPUT_OVERFLOW = 0x00000002
PA_OUTPUT_UNDERFLOW = 0x00000004
PA_OUTPUT_OVERFLOW = 0x00000008
PA_PRIMING_OUTPUT = 0x00000010
PA_CONTINUE = 0
PA_COMPLETE = 1
PA_ABORT = 2

# structs
PaHostApiInfo = ffi.Struct [
	['int','struct_version'],
	[PA_HOST_API_TYPE_ID,'type'],
	['string','name'],
	['int','device_count'],
	[PA_DEVICE_INDEX,'default_input_device'],
	[PA_DEVICE_INDEX,'default_output_device']
]
PaHostErrorInfo = ffi.Struct [
	[PA_HOST_API_TYPE_ID,'host_api_type'],
	['long','error_code'],
	['string','error_text']
]
PaDeviceInfo = ffi.Struct [
	['int','struct_version'],
	['string','name'],
	[PA_HOST_API_INDEX,'host_api'],
	['int','max_input_channels'],
	['int','max_output_channels'],
	[PA_TIME,'default_low_input_latency'],
	[PA_TIME,'default_low_output_latency'],
	[PA_TIME,'default_high_input_latency'],
	[PA_TIME,'default_high_output_latency'],
	['double','default_sample_rate']
]
PaStreamParameters = ffi.Struct [
	[PA_DEVICE_INDEX,'device_count'],
	['int','channel_count'],
	[PA_SAMPLE_FORMAT,'sample_format'],
	[PA_TIME,'suggested_latency'],
	['pointer','host_specific_stream_info']
	#TODO: the from_options method
]
PaStreamInfo = ffi.Struct [
	['int','struct_version'],
	[PA_TIME,'input_latency'],
	[PA_TIME,'output_latency'],
	['double','sample_rate']
]

module.exports.verison_number = -> portaudio.Pa_GetVersion()
module.exports.version_text = -> portaudio.Pa_GetVersionText()
module.exports.error_text = (pa_err)-> portaudio.Pa_GetVersionText(pa_err)
module.exports.init = -> portaudio.Pa_Initialize()
module.exports.terminate = -> portaudio.Pa_Terminate()
module.exports.sleep = (msec)-> portaudio.Pa_GetVersionText(msec)

