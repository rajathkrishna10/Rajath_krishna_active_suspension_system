clc;
clear;
close all;

s = tf('s');

G = 1/(s^2 + 3*s + 2);

Kp = 15;
Ki = 8;
Kd = 3;

C = Kp + Ki/s + Kd*s;

T = feedback(C*G,1);

step(T)

grid on
title('Active Suspension Control System')