#include <portaudio.h>
#include <stdio.h>
#include <stdlib.h>
#include <unistd.h>
#define SAMPLE_RATE (44100)


int handleErrors(err) {
	if (err != 0) {
		printf("PortAudio error: %s\n", Pa_GetErrorText(err) );
		exit(err);
	}
	return err;
}

int init() {
	return handleErrors(Pa_Initialize());
}

int terminate() {
	return handleErrors(Pa_Terminate());
}

// this is what the javascript callbacks will look like
typedef int SimpleCallback(float * buffer[],
													 int channels,
													 unsigned long framesPerChannel);

// this data is passed to paCallback as userData, so that it can call the SimpleCallback
typedef struct {
	int channels;
	SimpleCallback * callback;
} SimpleCallbackData;

int paCallback( const void *inputBuffer, void *outputBuffer,
                           unsigned long framesPerBuffer,
                           const PaStreamCallbackTimeInfo* timeInfo,
                           PaStreamCallbackFlags statusFlags,
                           void *userData )
{
    /* Cast data passed through stream to our structure. */
    SimpleCallbackData *data = (SimpleCallbackData*)userData; 
		int channels = data->channels;
		//float buffer[channels][framesPerBuffer];
		//float *out[] = (*float[])outputBuffer;
    //int i;
		//unsigned int j;
    (void) inputBuffer; /* Prevent unused variable warning. */


		/*
		 * TODO
		 *
		 * FUCK THIS NOISE
		 * do all the de-interleaving in JS
		 */

		// de-interleave it into arrays
/*		for(j=0; j<channels; j++)
		{
			for(i=0; i<framesPerBuffer; i++)
			{
				buffer[j][i] = *out++;
			}
		}   */



/*		for(j=0; j<channels; j++)
		{
			for(i=0; i<framesPerBuffer; i++)
			{
				 *out++ = buffer[j][i];
			}
		} */


    return data->callback(outputBuffer,channels,framesPerBuffer);
}

PaStream * openstream (SimpleCallback * callback,
											 int sampleRate,
											 int channels,
											 unsigned long framesPerBuffer) {

	  int frames = framesPerBuffer;
		if (frames < 1) frames = paFramesPerBufferUnspecified;
		SimpleCallbackData data = {channels,callback};
		PaStream *stream;
    PaError err;

    /* Open an audio I/O stream. */
    err = Pa_OpenDefaultStream( &stream,
                                0,          /* no input channels */
                                2,          /* stereo output */
                                paFloat32,  /* 32 bit floating point output */
                                sampleRate,
																frames,
                                /*256,  */      /* frames per buffer, i.e. the number
                                                   of sample frames that PortAudio will
                                                   request from the callback. Many apps
                                                   may want to use
                                                   paFramesPerBufferUnspecified, which
                                                   tells PortAudio to pick the best,
                                                   possibly changing, buffer size.*/
                                paCallback, /* this is your callback function */
                                &data ); /*This is a pointer that will be passed to
                                                   your callback*/
    handleErrors(err);

		return stream;
}

int closestream(PaStream * stream) {
	return handleErrors(Pa_CloseStream( stream ));
}

int startstream(PaStream *stream) {
	return handleErrors(Pa_StartStream( stream ));
}

int stopstream(PaStream *stream) {
	return handleErrors(Pa_StopStream( stream ));
}

//testing

int test_callback(float * buffer [],int channels, unsigned long frames)
{
	unsigned long j;
	for (j = 0; j<frames; j++)
	{
		buffer[j][0] += 0.01f;
		if (buffer[j][0] >= 1.0f) buffer[j][0] -= 2.0f;
		buffer[j][1] += 0.03f;
		if (buffer[j][1] >= 1.0f) buffer[j][1] -= 2.0f;
	}
	return 0;
}
  
int openstream_test() {
	init();
	PaStream * stream = openstream(&test_callback,SAMPLE_RATE,2,256);
	startstream(stream);
	sleep(5);
	printf("lol");
	stopstream(stream);
	closestream(stream);
	terminate();
	return 0;
}

int main() {
	return openstream_test();
}

