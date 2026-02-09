/* =========================================================
   SOUND CREATURE — AUD722
    Xristos Papadimitriou - TX2019037
   ========================================================= */

s.boot;

// LOAD BODY
~path = thisProcess.nowExecutingPath.dirname ++ "/creature_body2.wav";
~buf = Buffer.read(s, ~path);

// CREATURE
SynthDef(\soundCreature, {
    arg out = 0, state = 0, danger = 0,
        ring = 1, breath = 1, space = 1, amp = 1;
    var body, soul, sig, env, freq, pan, rm;

    body = PlayBuf.ar(2, ~buf, loop: 1).mean;

    // circadian states
    freq = Select.kr(state, [120, 260, 90, 40]);

    // emergency override
    freq = Select.kr(danger, [freq, freq * 6, freq * 12, 30]);

    soul = SinOsc.ar(freq);

    // STRONG ring modulation
    rm = (soul * ring * 4).tanh;
    sig = body * rm;

    // STRONG breathing
    env = Select.kr(state, [
        EnvGen.kr(Env.asr(6/breath, 1, 6/breath)),
        EnvGen.kr(Env.asr(2/breath, 1, 2/breath)),
        EnvGen.kr(Env.asr(4/breath, 1, 4/breath)),
        EnvGen.kr(Env.asr(10/breath, 1, 10/breath))
    ]);

    sig = sig * env * amp;

    // STRONG space motion
    pan = LFNoise1.kr(0.3 * space).range(-1, 1);
    sig = Pan2.ar(sig, pan);

    Out.ar(out, sig);
}).add;

// ----------FUNCTIONS---------

// start / stop
~go = { ~creature = Synth(\soundCreature) };
~kill = { ~creature.free };

// circadian
~dawn  = { ~creature.set(\state, 0) };
~day   = { ~creature.set(\state, 1) };
~dusk  = { ~creature.set(\state, 2) };
~night = { ~creature.set(\state, 3) };

// danger
~danger0 = { ~creature.set(\danger, 0) };
~danger1 = { ~creature.set(\danger, 1) };
~danger2 = { ~creature.set(\danger, 2) };
~danger3 = { ~creature.set(\danger, 3) };

// effects
~ringStrong   = { ~creature.set(\ring, 1) };
~ringGhost   = { ~creature.set(\ring, 0.2) };

~spaceWide   = { ~creature.set(\space, 1) };
~spaceStill  = { ~creature.set(\space, 0.05) };

~breathFast  = { ~creature.set(\breath, 3) };
~breathSlow  = { ~creature.set(\breath, 0.4) };

// ---------- ONE-BUTTON CONTROLS ----------

// start / stop
~kill.value;
~go.value;

// circadian
~dawn.value;
~day.value;
~dusk.value;
~night.value;

// danger
~danger0.value;
~danger1.value;
~danger2.value;
~danger3.value;

// effects
~ringStrong.value;
~ringGhost.value;

~spaceWide.value;
~spaceStill.value;

~breathFast.value;
~breathSlow.value;