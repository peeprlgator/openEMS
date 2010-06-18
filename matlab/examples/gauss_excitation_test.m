%
% this script evaluates the same gaussian excitation function, as openEMS does
%

clear
close all

f0 = 0;
fc = 10e9;
dT = 8e-12; % sample time-step






len = 2 * 9/(2*pi*fc) / dT; % gauss length

for n=1:len
    ex(n)=cos(2*pi*f0*((n-1)*dT - 9/(2*pi*fc))) .* exp(-1*(2*pi*fc*(n-1)*dT/3-3).^2);
    t_(n)=(n-1)*dT;
end

plot(t_/1e-9,ex)
xlabel( 'time (ns)' );
ylabel( 'amplitude' );

disp( ['Amplitude at t=0: ' num2str(20*log10(abs(ex(1))/1)) ' dB'] );

val = DFT_time2freq( t_, ex, [f0-fc f0 f0+fc] );
disp( ['Amplitude at f=f0-fc: ' num2str(20*log10(abs(val(1))/abs(val(2)))) ' dB'] );
disp( ['Amplitude at f=f0+fc: ' num2str(20*log10(abs(val(3))/abs(val(2)))) ' dB'] );

% calculate frequency domain via slow DFT
freq = linspace(f0-fc,f0+fc,1000);
val = DFT_time2freq( t_, ex, freq );
figure
plot( freq/1e9, abs(val) )

% overlay the FFT result
[f,val_fft] = FFT_time2freq( t_, ex );
val_fft = val_fft((f0-fc<=f) & (f<=f0+fc));
f = f((f0-fc<=f) & (f<=f0+fc));
hold on
plot( f/1e9, abs(val_fft), 'r' )

xlabel( 'frequency (GHz)' );
ylabel( 'amplitude' );

% dB
figure
val = val(freq>=0);
freq = freq(freq>=0);
plot( freq/1e9, 20*log10(abs(val)/max(abs(val))), 'r' )
xlabel( 'frequency (GHz)' );
ylabel( 'amplitude (dB)' );
