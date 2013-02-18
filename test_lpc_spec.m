% lpc_spectrum: plot FFT + superimposed LPC spectrum
clear all
[x,rate]=wavread('Jesse_normal_trimmed_11k.wav');

window_size = 512

samples_inc = 5000;
samples_per_ms = 11000 / 1000;
step = samples_per_ms * 5; % 5 ms step
% num of pts for DFT
nfft=window_size;

% frequency range of ft analysis (based on nyquist value and rate of wav
% file)
freq=linspace(0,rate/2,nfft/2+1);

hw = hamming(window_size);
p=12;
for i = 1:step:samples_inc

    w=x(i:(i + window_size - 1));

    w=w .* hw;
    a=lpc(w,p);

    fft_w = fft( w, nfft );
    fft_logmag = 20 * log10 ( abs( fft_w  ) );
    fft_logmag = fft_logmag(1:nfft/2+1);
    plot(freq,fft_logmag,'b');

    fft_a = fft( a, nfft );
    lpc_logmag = -20 * log10 ( abs( fft_a ) );
    lpc_logmag = lpc_logmag(1:nfft/2+1);
    hold on;
    plot(freq,lpc_logmag-3,'b');
    hold off
    xlabel('Frequency (Hz)')
    ylabel('Magnitude (dB)')
    pause (0.005);
end