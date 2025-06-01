
% create_fuzzy_gain_controller.m
% This script creates a FIS for adaptive gain in the fuzzy sliding mode controller

fis = mamfis('Name', 'GainController');

% Input 1: Error
fis = addInput(fis, [-1 1], 'Name', 'Error');
fis = addMF(fis, 'Error', 'trapmf', [-1 -1 -0.5 -0.1], 'Name', 'Negative');
fis = addMF(fis, 'Error', 'trimf', [-0.2 0 0.2], 'Name', 'Zero');
fis = addMF(fis, 'Error', 'trapmf', [0.1 0.5 1 1], 'Name', 'Positive');

% Input 2: Derivative of Error
fis = addInput(fis, [-1 1], 'Name', 'dError');
fis = addMF(fis, 'dError', 'trapmf', [-1 -1 -0.5 -0.1], 'Name', 'Negative');
fis = addMF(fis, 'dError', 'trimf', [-0.2 0 0.2], 'Name', 'Zero');
fis = addMF(fis, 'dError', 'trapmf', [0.1 0.5 1 1], 'Name', 'Positive');

% Output: Gain
fis = addOutput(fis, [100 1000], 'Name', 'Gain');
fis = addMF(fis, 'Gain', 'trimf', [100 200 400], 'Name', 'Low');
fis = addMF(fis, 'Gain', 'trimf', [300 500 700], 'Name', 'Medium');
fis = addMF(fis, 'Gain', 'trimf', [600 800 1000], 'Name', 'High');

% Rule base
rules = [
    "If Error is Negative and dError is Negative then Gain is High"
    "If Error is Negative and dError is Zero then Gain is Medium"
    "If Error is Negative and dError is Positive then Gain is Low"
    "If Error is Zero and dError is Zero then Gain is Medium"
    "If Error is Positive and dError is Negative then Gain is Low"
    "If Error is Positive and dError is Zero then Gain is Medium"
    "If Error is Positive and dError is Positive then Gain is High"
];

fis = addRule(fis, rules);

% Save the FIS to a file
writeFIS(fis, 'fuzzy_gain_controller');

% View the FIS editor
fuzzy(fis);
