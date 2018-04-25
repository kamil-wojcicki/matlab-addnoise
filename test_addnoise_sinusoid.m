% TEST_ADDNOISE_SINUSOID Synthetic signal demo for ADDNOISE routine.
%
%   See also ADDNOISE, TEST_ADDNOISE_SPEECH.

%   Author: Kamil Wojcicki, UTD, July 2011

clear all; close all; clc; randn('seed',0); rand('seed',0); fprintf('.\n');


    % inline function for SNR calculation
    SNRdB = @(s,n)( 10*log10(sum(s(:).^2)/sum((n(:)-s(:)).^2)) ); 

    % inline function for periodogram spectrum computation
    psd = @(x,w,nfft)( ...
        10*log10(abs(fft(x(:).'*diag(w(length(x))),nfft)).^2/length(x)) );

    snr = 5;                            % desired SNR level (dB)

    fs = 16000;                         % sampling frequency (Hz)
    Ts = 1/fs;                          % sampling period (s)
    duration = 20;                      % signal duration (ms)

    time = [ 0:Ts:duration*1E-3 ];      % time vector (s)
    N = length( time );                 % signal length (samples)
    nfft = 2^nextpow2( 2*N );           % FFT analysis length
    freq = [ 0:nfft-1 ]/nfft*fs;        % frequency vector (Hz)

    amplitudes   = [    1 0.25 ];       % vector of sine amplitudes
    frequencies  = [  300 2700 ];       % vector of sine frequencies
    angles       = [ pi/3    0 ];       % vector of sine phases
    C = length( frequencies );          % number of sinusoid components 

    % generate individual sinusoid component signal samples
    signal = sum( diag(amplitudes) * sin(2*pi*diag(frequencies) * ...
                        repmat(time,C,1) + repmat(angles(:),1,N)), 1 ); 

    % generate white Gaussian noise (by defult: unit mean, unit variance)
    noise = randn( size(signal) );

    % get mixture signal at a desired SNR level
    noisy = addnoise( signal, noise, snr );

    % compute spectral representations of target and mixture signals
    Pss = psd( signal, @hamming, nfft );
    Pnn = psd( noisy, @hamming, nfft );

    % compare true and desired SNRs
    fprintf( ' Desired SNR: %0.2f dB\n', snr );
    fprintf( 'Measured SNR: %0.2f dB\n', SNRdB(signal,noisy) );

    % generate time and frequency domain plots
    hfig = figure( 'Position', [10 30 550 400], ... 
        'PaperPositionMode', 'auto', 'Visible', 'on', 'color', 'w' ); 

    % plot time domain waveforms
    subplot( 2,1,1 ); hold on;
    plot( time, signal, 'color', [1 1 1]*0.5 ); 
    plot( time, noisy, 'ro', 'MarkerSize', 3 );
    set( gca, 'box', 'off' );
    xlim( [ min(time) max(time) ] );
    ylim( [ -2 2 ] );
    xlabel( 'Time (s)' );
    ylabel( 'Amplitude' );

    % plot spectral magnitude responses
    subplot( 2,1,2 ); hold on;
    plot( freq, Pss, 'color', [1 1 1]*0.5 ); 
    plot( freq, Pnn, 'r-' );
    set( gca, 'box', 'off' );
    xlim( [ min(freq) fs/2 ] );
    ylim( [ -75 20 ] );
    xlabel( 'Frequency (Hz)' );
    ylabel( 'Power (dB)' );

    % print figure to png
    print( '-dpng', sprintf('%s.png',mfilename) );


%%% EOF
