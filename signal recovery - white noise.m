clear;
close all
clc
[file, fs] = audioread('Easy_to_Love_voice_only.wav'); 
windowLength = 1024; 
hafifa = round(windowLength * 0.25); 
[stftMatrix, f, t] = stft(file, fs, 'Window', hamming(windowLength), 'OverlapLength', hafifa, 'FFTLength', windowLength);
harmonicMatrix = zeros(size(stftMatrix));
for i = 1:length(t)
    spectrum = abs(stftMatrix(:, i)); 
    value = max(spectrum) * 0.1; 
    goodvalue = find(spectrum > value); 
       harmonicMatrix(goodvalue, i) = stftMatrix(goodvalue, i); % שמירת תדרים דומיננטיים
end
reconstructedSignal = istft(harmonicMatrix, fs, 'Window', hamming(windowLength), 'OverlapLength', hafifa, 'FFTLength', windowLength);
lengthOriginal = length(file); 
lengthReconstructed = length(reconstructedSignal); 
if lengthOriginal < lengthReconstructed
    minLength = lengthOriginal;
else
    minLength = lengthReconstructed; 
end
% חיתוך האותות כך שיתאימו לאותו אורך
originalSignal = file(1:minLength); % חיתוך האות המקורי
reconstructedSignal = reconstructedSignal(1:minLength); % חיתוך האות המשוחזר
figure;
indices = 1:minLength;
Seconds = indices / fs;
subplot(2, 1, 1);
plot(Seconds, originalSignal, 'b'); 
title('Original Signal');
xlabel('Time (s)');
ylabel('Amplitude');
grid on;
subplot(2, 1, 2);
plot(Seconds, reconstructedSignal, 'r'); 
title('Reconstructed Signal');
xlabel('Time (s)');
ylabel('Amplitude');
grid on;
sound(reconstructedSignal,fs);
