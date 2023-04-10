[music, Fs] = audioread("vocal_music.wav");
[drums] = audioread("20221116094238-fa59674762-vocal_music_demucs3mdxextra_drums.[mvsep.com].mp3");
musicsignal=[music(:, 1);zeros(length(drums(:, 1))-length(music(:, 1)), 1)];
figure();
plot(abs(fftshift(fft(musicsignal))));
drum = drums(:, 1);
musicsignal = musicsignal/norm(musicsignal);
drum = drum/norm(drum);
maxm = max(max(abs(drum), max(abs(musicsignal))));
drum = drum/maxm;
musicsignal = musicsignal/maxm;

%%%% part for stft


DRUMSTFT = fft(drum);
MUSICSIGNALSTFT = fft(musicsignal);
[b, a] = butterbp(4000, 6000,  Fs);
z = filter(b, a, musicsignal);
figure();
plot(abs(fftshift(fft(z))));





[music, Fs] = audioread("vocal_music.wav");
[drums] = audioread("60_TablaClose_02_239_SP.wav");
drumsignal=[drums(:, 1); zeros(-length(drums(:, 1))+length(music(:, 1)), 1)];
drum = drumsignal;
musicsignal = music(:, 1);
musicsignal = musicsignal/norm(musicsignal);
drum = drum/norm(drum);
maxm = max(max(abs(drum), max(abs(musicsignal))));
drum = drum/maxm;
musicsignal = musicsignal/maxm;

%%%% part for stft
windowLength = 128;
fftLength = 512;
overlapLength = 96;
win = hann(windowLength,"periodic");



DRUMSTFT = stft(drum, Fs, Window=win,OverlapLength=overlapLength,FFTLength=fftLength,FrequencyRange="onesided");
MUSICSIGNALSTFT = stft(musicsignal, Fs, Window=win,OverlapLength=overlapLength,FFTLength=fftLength,FrequencyRange="onesided");


bin_classifier = abs(DRUMSTFT) >= abs(MUSICSIGNALSTFT);

classified_voice_ft = MUSICSIGNALSTFT.*(bin_classifier);
classified_voice1 = istft(classified_voice_ft,Window=win,OverlapLength=overlapLength,FFTLength=fftLength,FrequencyRange="onesided");



classified_voice1 = [classified_voice1; zeros((length(z)-length(classified_voice1)), 1)];



enhanced = z+classified_voice1;
sound(10*enhanced, Fs);