clear;
clc;
[file, fs] = audioread('Easy_to_Love_voice_only.wav'); 
windowLength = 1024; 
hafifa = round(windowLength * 0.25); % חפיפה של 25%
% חישוב STFT
[stftMatrix, f, t] = stft(file, fs, 'Window', hamming(windowLength), 'OverlapLength', hafifa, 'FFTLength', 8*windowLength);
Energy = sum(abs(stftMatrix).^2, 1); % אנרגיה עבור כל חלון
situation = zeros(1, length(Energy)); 
energycheck = 0.05 * max(Energy); % סף קטן יותר לזיהוי פעילות קולית
for i = 1:length(Energy)
    if Energy(i) >= energycheck
        situation(i) = 1; % חלון רועש
    else
        situation(i) = 0; % חלון שקט
    end
end
pitch = zeros(1, length(t)); 
for i = 1:length(t)
    if situation(i) == 1 
        spectrum = abs(stftMatrix(:, i));  
        spectrum = spectrum(f >= 50 & f <= 500); % סינון ספקטרום
        [maxvalue, index] = max(spectrum);% מוצא את המקסימלים
         pitch(i)  = spectrum(index);
    else
        % חלון שקט
        pitch(i) = 0;
    end
end
% הצגת STFT
figure;
subplot(2, 1, 1);
spectrogram(file, hamming(windowLength), hafifa, windowLength, fs, 'yaxis');
title('STFT');
xlabel('Time (s)');
ylabel('Frequency (Hz)');
colorbar;

%  Pitch
subplot(2, 1, 2);
plot(t, pitch, '.r', 'LineWidth', 2);
title('Pitch ');
xlabel('Time (s)');
ylabel('Frequency (Hz)');
grid on;
