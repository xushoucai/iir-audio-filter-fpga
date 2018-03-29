%% Data
% Starting from the difference equation of the filter, it's possible to compute
% the transfer function as
% tf = (1/4 z^-4 -1/4)/(1 - z^-1)
% so the coefficients of the numerator and denominator are
num_coeff = [-1/4 0 0 0 1/4];
den_coeff = [1 -1];
% this filter can be used using the filter() function

% Designing the filter in fixed point aritmetic
iir = dfilt.df2;
set(iir, 'arithmetic', 'fixed', ...
    'OutputMode', 'SpecifyPrecision', ...
    'Numerator', num_coeff, ...
    'Denominator', den_coeff, ...
    'InputWordLength',16, ...            
    'InputFracLength', 0, ...            
    'OutputWordLength', 16, ...           
    'OutputFracLength', 2, ...
    'StateWordLength', 16, ...        
    'StateFracLength', 0, ...
    'ProductMode', 'SpecifyPrecision', ...
    'ProductWordLength', 18, ...
    'NumProdFracLength', 2, ...
    'DenProdFracLength', 2, ...
    'AccumMode', 'SpecifyPrecision', ...
    'AccumWordLength', 18, ...
    'NumAccumFracLength', 2, ...
    'DenAccumFracLength', 2, ...
    'CastBeforeSum', false);

% check the frequency response of the filter
fvtool(iir);


%% Test with audio signals

% Read the audio samples from the WAV file as int16 array
[synth_original, Fs_synth] = audioread('wav/Synthesizer.wav', 'native');
[street_original, Fs_street] = audioread('wav/Street.wav', 'native');

% Convert the int16 audio samples into 16 bit signed fixed values
synth_fix = fi(synth_original, true, 16, 0);
street_fix = fi(street_original, true, 16, 0);

% Filter the audio signal
synth_filtered_fix = filter(iir, synth_fix);
street_filtered_fix = filter(iir, street_fix);

% Save the filtered audio in a WAV file
audiowrite('wav/SynthesizerFiltered.wav', int16(synth_filtered_fix), Fs_synth);
audiowrite('wav/StreetFiltered.wav', int16(street_filtered_fix), Fs_street);

%% Save data for testbenches in txt files

buildTxtFiles('synth', synth_fix, synth_filtered_fix);
buildTxtFiles('street', synth_fix, synth_filtered_fix);

