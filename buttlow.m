function [nz, dz] = buttlow(fp1, Fs)
As = 60;
%Butterworth Analog LPF parameters
Wc = 1;              %cut-off frequency                 

Rp = 1.1103;  

%Band Edge speifications
fs1 = 1.2*fp1;


%Transformed Band Edge specs using Bilinear Transformation

ws1 = (tan((fs1/Fs)*pi));          
wp1 = (tan((fp1/Fs)*pi));




N = ceil(abs(log10((10^(Rp/10)-1)/(10^(As/10)-1)))/abs((2*log10(wp1/ws1))))
N=3;
[z,p,k] = buttap(N);
[num,den] = zp2tf(z, p,k);

%Evaluating Frequency Response of Final Filter
syms s z;
analog_lpf(s) = poly2sym(num,s)/poly2sym(den,s);    %analog lpf transfer function
analog_bpf(s) = analog_lpf((s/wp1));     %bandpass transformation
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
                                      %frequency response in dB

%magnitude plot (not in log scale) 
end
                                                                                                    