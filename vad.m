clear
close all
clc

[file, fs] = audioread('voice.wav'); % קריאה של קובץ השמע
windowLength = 1024; % אורך חלון
overlap = round(windowLength * 0.25); % חישוב חפיפה
stepSize = windowLength - overlap; % התקדמות בין חלונות
windows = buffer(file, windowLength, overlap); % חלוקה לחלונות
energy = sum(windows.^2, 1) / windowLength; % חישוב האנרגיה עבור כל חלון
energyThreshold = 0.1 * max(energy); % סף זיהוי אנרגיה

% זיהוי חלונות רועשים/שקטים
situation = zeros(1, length(energy)); 
for i = 1:length(energy)
    if energy(i) >= energyThreshold
        situation(i) = 1; % חלון רועש
    else
        situation(i) = 0; % חלון שקט
    end
end

% חלון 1: גרף האנרגיה הכוללת
subplot(2, 2, 1); % יוצר גרף בפינה השמאלית העליונה
plot(energy, 'b', 'LineWidth', 1.5); % ציור גרף האנרגיה
title('Energy of All Windows');
xlabel('Window Index');
ylabel('Energy');
grid on;
% חלון 2: אות המקור
subplot(2, 2, 2); % יוצר גרף בפינה הימנית העליונה
plot(file);
title('Original Signal');
xlabel('Samples');
ylabel('Amplitude');
axis tight;
grid on;
% חלון 3: גרף מצב VAD
subplot(2, 2, [3 4]); 
stairs(situation, 'LineWidth', 1.5);
title('VAD Status (Active/Inactive)');
xlabel('Window Index');
ylabel('Status');
grid on;
axis tight;
