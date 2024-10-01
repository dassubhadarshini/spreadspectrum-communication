clc;
clear;

% Generation of bit pattern
s = round(rand(1, 25));    % Generating 25 bits
signal = [];  
carrier = [];
t = 0:2*pi/119:2*pi;     % Creating 120 samples for one cosine 

for k = 1:25
    if s(1,k) == 0
        sig = -ones(1, 120);    % 120 minus ones for bit 0
    else
        sig = ones(1, 120);     % 120 ones for bit 1
    end
    c = cos(t);   
    carrier = [carrier c];
    signal = [signal sig];
end

subplot(4,1,1);
plot(signal);
axis([-100 3100 -1.5 1.5]);
title('\bf\it Original Bit Sequence');

% BPSK Modulation of the signal
bpsk_sig = signal .* carrier;   % Modulating the signal

subplot(4,1,2);
plot(bpsk_sig);
axis([-100 3100 -1.5 1.5]);
title('\bf\it BPSK Modulated Signal');

% Preparation of 6 new carrier frequencies
t1 = 0:2*pi/9:2*pi;
t2 = 0:2*pi/19:2*pi;
t3 = 0:2*pi/29:2*pi;
t4 = 0:2*pi/39:2*pi;
t5 = 0:2*pi/59:2*pi;
t6 = 0:2*pi/119:2*pi;

c1 = repmat(cos(t1), 1, 12);
c2 = repmat(cos(t2), 1, 6);
c3 = repmat(cos(t3), 1, 4);
c4 = repmat(cos(t4), 1, 3);
c5 = repmat(cos(t5), 1, 2);
c6 = cos(t6);

% Random frequency hops to form a spread signal
spread_signal = [];
for n = 1:25
    c = randi(6, 1, 1);
    switch(c)
        case 1
            spread_signal = [spread_signal c1];
        case 2
            spread_signal = [spread_signal c2];
        case 3
            spread_signal = [spread_signal c3];
        case 4
            spread_signal = [spread_signal c4];
        case 5        
            spread_signal = [spread_signal c5];
        case 6
            spread_signal = [spread_signal c6];
    end
end

subplot(4,1,3);
plot([1:3000], spread_signal);
axis([-100 3100 -1.5 1.5]);
title('\bf\it Spread Signal with 6 Frequencies');

% Spreading BPSK Signal into wider band with total of 12 frequencies
freq_hopped_sig = bpsk_sig .* spread_signal;

subplot(4,1,4);
plot([1:3000], freq_hopped_sig);
axis([-100 3100 -1.5 1.5]);
title('\bf\it Frequency Hopped Spread Spectrum Signal');

% Expressing the FFTs
figure;
subplot(2,1,1);
plot([1:3000], freq_hopped_sig);
axis([-100 3100 -1.5 1.5]);
title('\bf\it Frequency Hopped Spread Spectrum Signal and its FFT');

subplot(2,1,2);
plot([1:3000], abs(fft(freq_hopped_sig)));
title('\bf\it FFT of Frequency Hopped Spread Spectrum Signal');
