%% Microstrip transmission line design
% Width and length of a 50 ohm microstrip line on FR-4 (Homework 1).
%
% Design equations (valid for w/h <= 2):
%   A    = Z0/60 * sqrt((er+1)/2) + (er-1)/(er+1) * (0.23 + 0.11/er)
%   w/h  = 8*exp(A) / (exp(2*A) - 2)
%   eef  = (er+1)/2 + (er-1) / (2*sqrt(1 + 12*h/w))
%   lam  = c / f
%   lg   = lam / sqrt(eef)

clear; clc;

%% Specifications
Z0 = 50;          % Characteristic impedance (ohm)
er = 4.3;         % Relative permittivity of the substrate
h  = 1.6e-3;      % Substrate thickness (m)
f  = 2e9;         % Center frequency (Hz)
c  = 3e8;         % Speed of light (m/s)

%% Line width
A = Z0/60 * sqrt((er + 1)/2) + (er - 1)/(er + 1) * (0.23 + 0.11/er);
w_h = 8*exp(A) / (exp(2*A) - 2);   % Ratio w/h

if w_h > 2
    warning('w/h = %.3f is greater than 2: this formula is only valid for w/h <= 2.', w_h);
end

w = w_h * h;                       % Line width (m)

%% Effective permittivity and guided wavelength
eef = (er + 1)/2 + (er - 1) / (2*sqrt(1 + 12*h/w));
lambda  = c / f;                   % Free-space wavelength (m)
lambda_g = lambda / sqrt(eef);     % Guided wavelength (m)

%% Line length (at least 1.5 guided wavelengths)
L = 1.5 * lambda_g;

%% Results
fprintf('A                         = %.3f\n', A);
fprintf('w/h                       = %.3f\n', w_h);
fprintf('Line width, w             = %.2f mm\n', w*1e3);
fprintf('Effective permittivity    = %.2f\n', eef);
fprintf('Free-space wavelength     = %.2f m\n', lambda);
fprintf('Guided wavelength, lg     = %.1f mm\n', lambda_g*1e3);
fprintf('Line length, L (1.5 lg)   = %.1f mm\n', L*1e3);
