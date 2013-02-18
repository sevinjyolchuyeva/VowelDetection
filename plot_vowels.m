addpath('../mweka')

[dataName, attributeName, attributeType, data] = arffread('vowel/vowel.arff');

dataName
vowel = 3; %E as in head
%for v = 1:10
figure(1)
for i = 1:size(data, 1)
    if (data(i, 11) == vowel)
        plot(data(i, 1:10).'); axis([1 10, -6, 6]);
    end
    hold on
end
%end

figure(2)
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
for i = 150:step:500

    w=x(i:(i + window_size - 1));

    w=w .* hw;
    a=lpc(w,p);
    la=zeros(10, 1);
    for j = 2:11
        la(j - 1) = log((1 + a(j))/(1 - a(j)));
    end
    plot(la); axis([1 10, -6, 6]);
    xlabel(sprintf('Window: %d', i));
    hold on
end