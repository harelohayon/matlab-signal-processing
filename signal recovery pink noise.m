clear;
close all;
clc;

[file, fs] = audioread('Easy_to_Love_voice_only.wav');
windowLength = 1024;
hafifa = round(windowLength * 0.25);
pinkNoise = dsp.ColoredNoise('Color', 'pink', 'SamplesPerFrame', length(file), 'NumChannels', 1);
pinkNoiseSignal = pinkNoise();
noisySignal = file + 0.3 * pinkNoiseSignal;

[stftMatrix, f, t] = stft(noisySignal, fs, 'Window', hamming(windowLength), 'OverlapLength', hafifa, 'FFTLength', windowLength);
[originalStftMatrix, f1, t1] = stft(file, fs, 'Window', hamming(windowLength), 'OverlapLength', hafifa, 'FFTLength', windowLength);

% סינון על בסיס השוואת אנרגיה
reconstrudstfmatrix = zeros(size(stftMatrix)); 
for i = 1:length(t)
    noisySpectrum = abs(stftMatrix(:, i));
    originalSpectrum = abs(originalStftMatrix(:, i));
    noisyEnergy = sum(noisySpectrum .^ 2);
    originalEnergy = sum(originalSpectrum .^ 2);
    if noisyEnergy < originalEnergy
        reconstrudstfmatrix(:, i) = stftMatrix(:, i);
    else
        reconstrudstfmatrix(:, i) = originalStftMatrix(:,i);
    end
end
reconstructedSignal = istft(reconstrudstfmatrix, fs, 'Window', hamming(windowLength), 'OverlapLength', hafifa, 'FFTLength', windowLength);

% התאמת אורך
minLength = min([length(file), length(noisySignal), length(reconstructedSignal)]);
originalSignal = file(1:minLength);
noisySignal = noisySignal(1:minLength);
reconstructedSignal = reconstructedSignal(1:minLength);
% גרפים
time = (0:minLength-1) / fs;
figure;
subplot(3, 1, 1);
plot(time, originalSignal, 'b');
title('Original Signal');
xlabel('Time (s)');
ylabel('Amplitude');
grid on;

subplot(3, 1, 2);
plot(time, noisySignal, 'g');
title('Noisy Signal');
xlabel('Time (s)');
ylabel('Amplitude');
grid on;

subplot(3, 1, 3);
plot(time, reconstructedSignal, 'r');
title('Reconstructed Signal');
xlabel('Time (s)');
ylabel('Amplitude');
grid on;
sound(reconstructedSignal,fs);
