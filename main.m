clc;
clear;
close all;

s = tf('s');

% ── System Model ──────────────────────────────────────────
G = 1/(s^2 + 3*s + 2);

% ── PID Controller (with filtered derivative) ─────────────
Kp = 15;
Ki = 8;
Kd = 3;
tau = 0.01; % derivative filter constant

C = Kp + Ki/s + Kd*s/(tau*s + 1);

% ── Closed-Loop System ────────────────────────────────────
T = feedback(C*G, 1);

% ── Figure 1: Side-by-side step responses ─────────────────
figure;
subplot(1,2,1);
step(G);
title('Uncontrolled Suspension');
xlabel('Time (s)'); ylabel('Body Displacement');
grid on;

subplot(1,2,2);
step(T);
title('PID Controlled Suspension');
xlabel('Time (s)'); ylabel('Body Displacement');
grid on;

% ── Figure 2: Overlay comparison ──────────────────────────
figure;
step(G, T);
legend('Uncontrolled', 'PID Controlled');
title('Suspension Response Comparison');
xlabel('Time (s)'); ylabel('Body Displacement');
grid on;

% ── Performance Metrics ───────────────────────────────────
fprintf('===== UNCONTROLLED SYSTEM =====\n');
info_G = stepinfo(G);
fprintf('Settling Time : %.4f s\n', info_G.SettlingTime);
fprintf('Overshoot     : %.2f %%\n', info_G.Overshoot);
fprintf('Rise Time     : %.4f s\n', info_G.RiseTime);

fprintf('\n===== PID CONTROLLED SYSTEM =====\n');
info_T = stepinfo(T);
fprintf('Settling Time : %.4f s\n', info_T.SettlingTime);
fprintf('Overshoot     : %.2f %%\n', info_T.Overshoot);
fprintf('Rise Time     : %.4f s\n', info_T.RiseTime);

% Settling time requirement check
if info_T.SettlingTime < 5
    fprintf('\n✔ Settling time requirement MET (< 5s)\n');
else
    fprintf('\n✘ Settling time requirement NOT MET — retune gains\n');
end

% ── Damping Analysis ──────────────────────────────────────
fprintf('\n===== DAMPING ANALYSIS =====\n');
poles_G = pole(G);
poles_T = pole(T);
fprintf('Uncontrolled poles: '); disp(poles_G.');
fprintf('Controlled poles  : '); disp(poles_T.');

% Damping ratio from closed-loop poles
[wn, zeta] = damp(T);
fprintf('\nClosed-loop natural frequencies and damping ratios:\n');
for i = 1:length(wn)
    fprintf('  wn = %.4f rad/s,  zeta = %.4f\n', wn(i), zeta(i));
end
