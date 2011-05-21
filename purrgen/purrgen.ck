LiSa lisa => LPF lpf => dac;
SndBuf buffer;

"purr.wav" => buffer.read;
buffer.samples()::samp => dur buffer_length;
buffer_length => lisa.duration;

4 => lisa.maxVoices;
lisa.clear();
1.0 => lisa.gain;
0.5 => lisa.feedback;

4000 => lpf.freq;
1 => lpf.Q;

for (0 => int i; i < buffer.samples(); i++)
	lisa.valueAt(buffer.valueAt(i), i::samp);

//1 => lisa.sync;

while (true) {
	Std.rand2f(0.8, 1.2) => float newrate;
	Std.rand2f(2000, 3000) * 1::ms => dur newdur;
	spork ~ getgrain(newdur, 20::ms, 20::ms, newrate);
	10::ms => now;
}

fun void getgrain(dur grainlen, dur rampup, dur rampdown, float rate) {
    lisa.getVoice() => int newvoice;

    if(newvoice > -1) {
        lisa.rate(newvoice, rate);
        lisa.playPos(newvoice, Std.rand2f(0., 1.) * buffer_length);
        lisa.rampUp(newvoice, rampup);
        (grainlen - (rampup + rampdown)) => now;
        lisa.rampDown(newvoice, rampdown);
        rampdown => now;
    }
}
