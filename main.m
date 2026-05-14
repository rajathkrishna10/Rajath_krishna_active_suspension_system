clc;
clear;
close all;

%% ═══════════════════════════════════════════════
%  ACTIVE SUSPENSION CONTROL SYSTEM
%  Plant: G(s) = 1 / (s^2 + 3s + 2)
%  Controller: PID with filtered derivative
%% ═══════════════════════════════════════════════

s = tf('s');

%% 1. PLANT MODEL
% Second-order suspension transfer function
% Input: control force | Output: body displacement
G = 1 / (s^2 + 3*s + 2);

%% 2. PID CONTROLLER (Auto-tuned)
% Using MATLAB's pidtune for optimal gains
opts = pidtuneOptions('CrossoverFrequency', 4, 'PhaseMargin', 70);
C_auto = pidtune(G, 'PID', opts);

% Extract auto-tuned gains
Kp = C_auto.Kp;
Ki = C_auto.Ki;
Kd = C_auto.Kd;

fprintf('═══ Auto-tuned PID Gains ═══\n');
fprintf('Kp = %.4f\n', Kp);
fprintf('Ki = %.4f\n', Ki);
fprintf('Kd = %.4f\n', Kd);

% PID with filtered derivative (proper controller)
tau = 0.01;
C = Kp + Ki/s + Kd*s/(tau*s + 1);

%% 3. CLOSED-LOOP SYSTEM
T   = feedback(C*G, 1);   % closed-loop
S   = feedback(1, C*G);   % sensitivity (disturbance rejection)
CS  = feedback(C, G);     % controller effort

%% 4. STABILITY ANALYSIS
fprintf('\n═══ Stability Analysis ═══\n');
fprintf('Closed-loop poles:\n'); disp(pole(T).');

% Gain & phase margins
[Gm, Pm, Wcg, Wcp] = margin(C*G);
fprintf('Gain margin  : %.2f dB at %.2f rad/s\n', 20*log10(Gm), Wcg);
fprintf('Phase margin : %.2f deg at %.2f rad/s\n', Pm, Wcp);

if Pm > 45
    fprintf('✔ Phase margin sufficient (> 45 deg)\n');
else
    fprintf('✘ Phase margin too low — risk of oscillation\n');
end

%% 5. PERFORMANCE METRICS
fprintf('\n═══ Performance Metrics ═══\n');
info_G = stepinfo(G);
info_T = stepinfo(T);

fprintf('%-25s %-15s %-15s\n', 'Metric', 'Uncontrolled', 'PID Controlled');
fprintf('%s\n', repmat('-',1,55));
fprintf('%-25s %-15.4f %-15.4f\n', 'Settling time (s)', info_G.SettlingTime, info_T.SettlingTime);
fprintf('%-25s %-15.4f %-15.4f\n', 'Rise time (s)',     info_G.RiseTime,     info_T.RiseTime);
fprintf('%-25s %-15.4f %-15.4f\n', 'Overshoot (%)',     info_G.Overshoot,    info_T.Overshoot);
fprintf('%-25s %-15.4f %-15.4f\n', 'Peak (m)',          info_G.Peak,         info_T.Peak);

if info_T.SettlingTime < 5
    fprintf('\n✔ Settling time requirement MET (< 5s)\n');
else
    fprintf('\n✘ Settling time NOT MET — retune gains\n');
end

%% 6. DAMPING ANALYSIS
fprintf('\n═══ Damping Analysis ═══\n');
[wn, zeta] = damp(T);
fprintf('%-20s %-15s\n', 'Nat. freq (rad/s)', 'Damping ratio');
fprintf('%s\n', repmat('-',1,35));
for i = 1:length(wn)
    fprintf('%-20.4f %-15.4f\n', wn(i), zeta(i));
end

%% 7. PLOTS
% ── Figure 1: Step response comparison ───────────────────
figure('Name','Step Response Comparison');
step(G, T, 10);
legend('Uncontrolled', 'PID Controlled', 'Location', 'southeast');
title('Step Response — Uncontrolled vs PID Controlled');
xlabel('Time (s)'); ylabel('Body Displacement (m)');
grid on;

% ── Figure 2: Bode plot ───────────────────────────────────
figure('Name','Bode Plot');
bode(G, C*G, T);
legend('Plant G(s)', 'Open-loop C·G', 'Closed-loop T', 'Location', 'southwest');
title('Bode Plot');
grid on;

% ── Figure 3: Root locus ──────────────────────────────────
figure('Name','Root Locus');
rlocus(C*G);
title('Root Locus — PID Controlled System');
grid on;

% ── Figure 4: Sensitivity & disturbance rejection ─────────
figure('Name','Sensitivity');
bodemag(S, CS);
legend('Sensitivity S(s)', 'Control effort CS(s)', 'Location', 'southwest');
title('Sensitivity & Controller Effort');
xlabel('Frequency (rad/s)'); ylabel('Magnitude (dB)');
grid on;

% ── Figure 5: Pole-zero map ───────────────────────────────
figure('Name','Pole-Zero Map');
pzmap(G, T);
legend('Uncontrolled', 'PID Controlled');
title('Pole-Zero Map');
grid on;
