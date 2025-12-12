////////////////////////////////////////////////////////
// AUD722 - myCreature Project
////////////////////////////////////////////////////////

// 1. Boot server
s.waitForBoot {

    // 2.
	~body = Buffer.read(s, "[Εισαγωγή pathname που έχουμε αποθηκέυσει το αρχείο]");

    // 3. Define the creature SynthDef
    SynthDef(\myCreature, { |amp = 0.3, rate = 1.0, soulFreq = 200, out = 0|

        // BODY playback (STEREO)
        var body = PlayBuf.ar(
            numChannels: 2,                   // stereo buffer
            bufnum: ~body,
            rate: BufRateScale.kr(~body) * rate,
            doneAction: 2
        );

        // SOUL (sine wave)
        var soul = SinOsc.ar(freq: soulFreq);

        // RING MODULATION
        var ring = body * soul;

        // AMPLITUDE ENVELOPE
        var env = EnvGen.kr(
            Env.perc(0.01, 1.0, amp),          // simple envelope
            doneAction: 2
        );

        // STEREO output
        Out.ar(out, ring * env);

    }).add;

}; // <-- ONLY THIS closes waitForBoot

x = Synth(\myCreature, [\rate, 0.8, \soulFreq, 120]);

x = Synth(\myCreature);

x.free;





