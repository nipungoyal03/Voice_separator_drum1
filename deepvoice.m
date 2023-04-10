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
sound(10*z, Fs);

pause(30);
sound(20*z, Fs);