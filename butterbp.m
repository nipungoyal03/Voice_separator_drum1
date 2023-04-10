function [nz, dz] = butterbp(fp1, fp2, Fs)
As = 60;
%Butterworth Analog LPF parameters
Wc = 1;              %cut-off frequency                 

Rp = 5;  

%Band Edge speifications
fs1 = 0.78*fp1;
fs2 = 1.3*fp2;

%Transformed Band Edge specs using Bilinear Transformation

ws1 = abs(tan((fs1/Fs)*pi));     
wp1 = abs(tan((fp1/Fs)*pi));
wp2 = abs(tan((fp2/Fs)*pi));
ws2 = abs(tan((fs2/Fs)*pi));



W0 = sqrt(wp1*wp2);

B = abs(wp2-wp1);
W1 = ws1 - W0^2/ws1
W2 = ws2 - W0^2/ws2

Ws = min(([abs(W1),abs(W2)]));
N = ceil((log10((10^(Rp/10)-1)/(10^(As/10)-1)))/(2*log10(B/Ws)));
N = 5;

[z,p,k] = buttap(N);
[num,den] = zp2tf(z, p,k);

%Evaluating Frequency Response of Final Filter
syms s z;
analog_lpf(s) = poly2sym(num,s)/poly2sym(den,s);    %analog lpf transfer function
analog_bpf(s) = analog_lpf((s*s +W0*W0)/(B*s));     %bandpass transformation
discrete_bpf(z) = analog_bpf((z-1)/(z+1));          %bilinear transformation
discrete_bpf(z) = vpa(simplify(vpa(expand(discrete_bpf(z)), 20)), 20);

%coeffs of analog BPF
[ns, ds] = numden(analog_bpf(s));                   %numerical simplification
ns = sym2poly(expand(ns));                          
ds = sym2poly(expand(ds));                          %collect coeffs into matrix form
k = ds(1);    
ds = ds/k;
ns = ns/k;

%coeffs of discrete BPF
[nz, dz] = numden(discrete_bpf(z));                 %numerical simplification
nz = sym2poly(expand(nz));                          
dz = sym2poly(expand(dz));                          %collect coeffs into matrix form
k = dz(1);                                          %normalisation factor
dz = dz/k;
nz = nz/k;
end                                                                                                 