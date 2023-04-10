[music, Fs] = audioread("vocal_music.wav");
[drums] = audioread("20221116094238-fa59674762-vocal_music_demucs3mdxextra_drums.[mvsep.com].mp3");
musicsignal=[music(:, 1);zeros(length(drums(:, 1))-length(music(:, 1)), 1)];
drum = drums(:, 1);
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
classified_voice = istft(classified_voice_ft,Window=win,OverlapLength=overlapLength,FFTLength=fftLength,FrequencyRange="onesided");
sound(10*classified_voice, Fs);


