%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%          Microstrip Chebyshev low-pass filters           %%
%%                       Henrique Dutra                     %%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Design of a Chebyshev low-pass filter (fc = 1.9 GHz, 1 dB ripple,
% Z0 = 50 ohm) on FR-4, implemented as:
%   1. Lumped elements (L and C values)
%   2. Shunt stubs (Richards transform + Kuroda identities)
%   3. Stepped impedance, order 3
%   4. Stepped impedance, order 7
%
% Microstrip synthesis (Hammerstad):
%   w/h <= 2: A    = Z0/60*sqrt((er+1)/2) + (er-1)/(er+1)*(0.23 + 0.11/er)
%             w/h  = 8*exp(A) / (exp(2*A) - 2)
%   w/h  > 2: B    = 377*pi / (2*Z0*sqrt(er))
%             w/h  = 2/pi*(B - 1 - log(2B-1) + (er-1)/(2er)*(log(B-1) + 0.39 - 0.61/er))
%   eef  = (er+1)/2 + (er-1) / (2*sqrt(1 + 12*h/w))
%   lg   = c / (f*sqrt(eef)),   beta = 2*pi/lg
%
% Stepped-impedance section lengths:
%   inductor  (Zh): l = g_k*R0 / (Zh*beta)
%   capacitor (Zl): l = g_k*Zl / (R0*beta)

clear; clc;

%% Specifications
R0 = 50;          % Source/load impedance (ohm)
fc = 1.9e9;       % Cutoff frequency (Hz)
er = 4.4;         % Relative permittivity of FR-4
h  = 1.6e-3;      % Substrate thickness (m)
Zh = 110;         % High impedance for stepped impedance (ohm)
Zl = 22;          % Low impedance for stepped impedance (ohm)
c  = 3e8;         % Speed of light (m/s)
wc = 2*pi*fc;

% Normalized Chebyshev coefficients, 1 dB ripple (coefficient table)
g3 = [2.0236 0.9941 2.0236];
g7 = [2.1664 1.1116 3.0934 1.1736 3.0934 1.1116 2.1664];

% Length scaling factors found with HFSS optimization (-3 dB at fc)
p_kuroda = 1.205;
p_si3    = 0.944;
p_si7    = 0.807;

%% 1. Lumped elements (series L - shunt C - series L)
L = g3(1)*R0/wc;
C = g3(2)/(R0*wc);
fprintf('=== 1. Lumped elements ===\n');
fprintf('L1 = L3 = %.3f nH\n', L*1e9);
fprintf('C2      = %.3f pF\n\n', C*1e12);

%% 2. Richards transform + Kuroda identities
% Richards: series L -> series stub Z = g, shunt C -> shunt stub Z = 1/g
% Unit elements (Z = 1) are added at both ends, then Kuroda moves the
% series stubs to shunt stubs.
Z1 = g3(1);                 % series stub (normalized)
Z2 = 1;                     % unit element (normalized)
n2 = 1 + Z2/Z1;
Zk = R0*[1, 1/g3(2), n2*Z2, n2*Z1];   % 50 ohm feed, middle stub, Kuroda pair
fprintf('=== 2. Richards + Kuroda (stubs = lg/8 at fc) ===\n');
fprintf('n^2 = %.3f\n', n2);
fprintf('%10s %10s %10s %12s %12s\n', 'Z0 (ohm)', 'W (mm)', 'eef', 'L (mm)', 'L opt (mm)');
for Z = Zk
    [w, eef, lg] = microstrip(Z, er, h, fc, c);
    fprintf('%10.2f %10.3f %10.4f %12.3f %12.3f\n', Z, w*1e3, eef, lg/8*1e3, p_kuroda*lg/8*1e3);
end
fprintf('\n');

%% 3. and 4. Stepped impedance, orders 3 and 7
stepped_impedance(g3, R0, Zh, Zl, er, h, fc, c, p_si3);
stepped_impedance(g7, R0, Zh, Zl, er, h, fc, c, p_si7);

%% Local functions
function [w, eef, lg] = microstrip(Z0, er, h, f, c)
    A  = Z0/60*sqrt((er + 1)/2) + (er - 1)/(er + 1)*(0.23 + 0.11/er);
    wh = 8*exp(A)/(exp(2*A) - 2);
    if wh > 2   % wide strip: use the w/h > 2 formula
        B  = 377*pi/(2*Z0*sqrt(er));
        wh = 2/pi*(B - 1 - log(2*B - 1) + (er - 1)/(2*er)*(log(B - 1) + 0.39 - 0.61/er));
    end
    w   = wh*h;
    eef = (er + 1)/2 + (er - 1)/(2*sqrt(1 + 12*h/w));
    lg  = c/(f*sqrt(eef));
end

function stepped_impedance(g, R0, Zh, Zl, er, h, fc, c, p)
    N = numel(g);
    fprintf('=== Stepped impedance, order %d (p = %.3f) ===\n', N, p);
    fprintf('%8s %8s %8s %10s %10s %10s %12s\n', 'Section', 'Z0', 'W (mm)', 'eef', 'beta', 'L (mm)', 'L opt (mm)');
    for k = 1:N
        if mod(k, 2) == 1   % odd sections: series inductors -> Zh
            Z = Zh;
            [w, eef, lg] = microstrip(Z, er, h, fc, c);
            beta = 2*pi/lg;
            l = g(k)*R0/(Zh*beta);
        else                % even sections: shunt capacitors -> Zl
            Z = Zl;
            [w, eef, lg] = microstrip(Z, er, h, fc, c);
            beta = 2*pi/lg;
            l = g(k)*Zl/(R0*beta);
        end
        fprintf('%8d %8.0f %8.3f %10.4f %10.3f %10.3f %12.3f\n', k, Z, w*1e3, eef, beta, l*1e3, p*l*1e3);
    end
    fprintf('\n');
end
