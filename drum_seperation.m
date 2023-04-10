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


DRUMSTFT = fft(drum);
MUSICSIGNALSTFT = fft(musicsignal);
figure();
plot(abs(fftshift(DRUMSTFT)));
figure();
plot(abs(fftshift(MUSICSIGNALSTFT)));

% %%bin_classifier = abs(DRUMSTFT) >= abs(MUSICSIGNALSTFT);
% z = MUSICSIGNALSTFT;
% count = 0;
% for i=length(DRUMSTFT)/2:length(DRUMSTFT)
%     fre = ((i-(length(DRUMSTFT)/2))*2)/length(DRUMSTFT);
%     if abs(DRUMSTFT(i)) > abs(MUSICSIGNALSTFT(i))
%         [b, a]= notch(fre);
%         z = filter(a, b ,z);
%         count = count+1;
%     end
% 
%     if count ==6
%         break;
%     end
%     
% 
% 
% end
% 
% z = ifft(z);
% 
% 
% sound(abs(z), Fs);


