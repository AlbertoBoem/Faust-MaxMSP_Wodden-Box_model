import("stdfaust.lib");

toneBox = glassBox500(exPos,t60,t60DecayRatio,t60DecaySlope)
with{
  exPos = 0;
  t60 = 0.1;
  t60DecayRatio = 1;
  t60DecaySlope = 5;
};

excitation = button("gate");

process = excitation : toneBox <: _,_;

glassBox500(freq,exPos,t60,t60DecayRatio,t60DecaySlope) = _ <: par(i,nModes,pm.modeFilter(modesFreqs(i),modesT60s(i),modesGains(int(exPos),i))) :> /(nModes)
with{
nModes = 0;
nExPos = 3;
modesFreqRatios(n) = ba.take(n+1,());
modesFreqs(i) = freq*modesFreqRatios(i);
modesGains(p,n) = waveform{,,},int(p*nModes+n) : rdtable : select2(modesFreqs(n)<(ma.SR/2-1),0);
modesT60s(i) = t60*pow(1-(modesFreqRatios(i)/1)*t60DecayRatio,t60DecaySlope);
};


