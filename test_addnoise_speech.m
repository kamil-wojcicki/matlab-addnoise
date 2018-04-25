% TEST_ADDNOISE_SINUSOID Speech signal demo for ADDNOISE routine.
%
%   See also ADDNOISE, TEST_ADDNOISE_SINUSOID.

%   Author: Kamil Wojcicki, UTD, July 2011

clear all; close all; clc; randn('seed',0); rand('seed',0); fprintf('.\n');


    % inline function for SNR calculation
    SNRdB = @(s,n)( 10*log10(sum(s(:).^2)/sum((n(:)-s(:)).^2)) ); 

    % read target and masker samples from files
    [ speech, fs ] = audioread( 'sp10.wav' );
    [ noise, fs ] = audioread( 'ssn.wav' );

    % desired SNR level (dB)
    snr = 5; 

    % get mixture speech at a desired SNR level
    noisy = addnoise( speech, noise, snr );

    % compare true and desired SNRs
    fprintf( ' Desired SNR: %0.2f dB\n', snr );
    fprintf( 'Measured SNR: %0.2f dB\n', SNRdB(speech,noisy) );

    % generate time and frequency domain plots
    hfig = figure( 'Position', [10 30 550 400], ... 
        'PaperPositionMode', 'auto', 'Visible', 'on', 'color', 'w' ); 

    % plot time domain waveforms
    subplot( 2,1,1 ); hold on;
    myspectrogram( speech, fs, [18 1], @hanning, 1024, [-60 -2] );
    set( gca, 'ytick', [0:2000:fs/2], 'yticklabel', [0:2:round(0.5E-3*fs)] );
    xlabel( 'Time (s)' );
    ylabel( 'Frequency (kHz)' );

    % plot spectral magnitude responses
    subplot( 2,1,2 ); hold on;
    myspectrogram( noisy, fs, [18 1], @hanning, 1024, [-60 -2] );
    set( gca, 'ytick', [0:2000:fs/2], 'yticklabel', [0:2:round(0.5E-3*fs)] );
    xlabel( 'Time (s)' );
    ylabel( 'Frequency (kHz)' );

    % print figure to png
    print( '-dpng', sprintf('%s.png',mfilename) );


%%% EOF
