%load the info for the font

info

%choose which turbine to analyze

turbine= input ('Which turbine? 4, 5, 6, 7 or 8 baldes?: ');

switch turbine
    case 4
        load('Measurements\Z4\test');
    case 5
        load('Measurements/Z5/test.mat');
    case 6
        load('Measurements/Z6/test.mat');
    case 7
        load('Measurements/Z7/test.mat');
    case 8
        load('Measurements/Z8/test.mat');
    otherwise
        disp('Number is not 4, 5, 6, 7 or 8. No file loaded.');
        data = [];
end

%load the experimental data

piston_vel     = test.data(:,3);
air_velocity        = test.data(:,4);
deltaP          = test.data(:,6);
omega_rpm       = test.data(:,7);
omega = (omega_rpm) * 2*pi  / (60);
torque_aero     = test.data(:,9);

%define some geometric factors and boundry conditions

Ap=0.785;
h=0.03;
r_med=0.11;
tip_radius=0.125;
rho = test.rho;
At = 2 * pi * r_med * h ;

%flow rate

Q=piston_vel*Ap;

%define dimensional coefficients

flow_coef = air_velocity ./ (omega .* tip_radius);

torque_coef = torque_aero ./ (rho .* (omega).^2 .* tip_radius^5);

press_coef = deltaP ./ (rho .* (omega).^2 * tip_radius.^2);

efficency = (torque_aero .* omega) ./ (deltaP .* Q);

%U at the avergae blade span
U_aver = 2 * pi * r_med * omega_rpm / 60;

%velocity magnitude


C_star = sqrt(2 .* abs(deltaP) ./ rho);
W2s = sqrt(U_aver.^2 + C_star.^2);
C2u = -(torque_aero .* omega) ./ (U_aver .* piston_vel .* rho .* Ap);
C2ax = (piston_vel .* Ap) ./ At;
C2 = sqrt(C2u.^2 + C2ax.^2);
W2 = sqrt(C2ax.^2 + (U_aver + C2u).^2);
cosB2 = (U_aver + C2u) ./ W2;
W1=  sqrt(U_aver.^2 + air_velocity.^2 );

%Velocity reduction coefficients

lambda = U_aver ./ C_star;
psi = W2 ./ W2s;

%losses

rotor_losses = (1 - psi.^2) .* (1 + lambda.^2);
exit_losses = lambda.^2 + psi.^2 .* (1 + lambda.^2) - 2 .* psi .* lambda .* cosB2 .* sqrt(1 + lambda.^2);
efficency_ts = 2 .* lambda .* (psi .* cosB2 .* sqrt(1 + lambda.^2) - lambda);

%lets plot

figure(1)
plot(flow_coef , torque_coef, 'o', 'MarkerFaceColor', cyano, 'MarkerEdgeColor', cyano, 'MarkerSize', marker_size)
xlabel('Flow coefficient  $\phi^{*}$', 'Interpreter', 'latex', 'FontSize', font_axis)
ylabel('Torque coefficient $T^{*}$', 'Interpreter', 'latex', 'FontSize', font_axis)
xlim([-0.4 0.4]);
grid on


figure(2)
plot(flow_coef ,press_coef, 'o', 'MarkerFaceColor', cyano, 'MarkerEdgeColor', cyano, 'MarkerSize', marker_size)
xlabel('Flow coefficient  $\phi^{*}$', 'Interpreter', 'latex', 'FontSize', font_axis)
ylabel('Pressure coefficient $p^{*}$', 'Interpreter', 'latex', 'FontSize', font_axis)
xlim([-0.4 0.4]);
grid on

figure(3)
plot(flow_coef, efficency, 'o', 'MarkerFaceColor', cyano, 'MarkerEdgeColor', cyano, 'MarkerSize', marker_size)
xlabel('Flow coefficient  $\phi^{*}$', 'Interpreter', 'latex', 'FontSize', font_axis)
ylabel('Efficiency $\eta$', 'Interpreter', 'latex', 'FontSize', font_axis)
ylim([0 1]);
xlim([-0.4 0.4]);
grid on

figure(4)
plot(flow_coef ,rotor_losses, 'o', 'MarkerFaceColor', cyano, 'MarkerEdgeColor', cyano, 'MarkerSize', marker_size)
xlabel('Flow coefficient  $\phi^{*}$', 'Interpreter', 'latex', 'FontSize', font_axis)
ylabel('Aerodynamic losses $\xi_{\mathrm{R}}$', 'Interpreter', 'latex', 'FontSize', font_axis)
ylim([0 1]);
xlim([-0.3 0]);
grid on

figure(5)
plot(flow_coef ,exit_losses , 'o', 'MarkerFaceColor', cyano, 'MarkerEdgeColor', cyano, 'MarkerSize', marker_size)
xlabel('Flow coefficient  $\phi^{*}$', 'Interpreter', 'latex', 'FontSize', font_axis)
ylabel('Exit losses $\xi_{\mathrm{exit}}$', 'Interpreter', 'latex', 'FontSize', font_axis)
ylim([0 0.5]);
xlim([-0.3 0]);
grid on

figure(6)
plot(flow_coef ,efficency_ts, 'o', 'MarkerFaceColor', cyano, 'MarkerEdgeColor', cyano, 'MarkerSize', marker_size)
xlabel('Flow coefficient  $\phi^{*}$', 'Interpreter', 'latex', 'FontSize', font_axis)
ylabel('Total-to-static efficiency $\eta_{\mathrm{ts}}$', 'Interpreter', 'latex', 'FontSize', font_axis)
ylim([0 1]);
xlim([-0.3 0]);
grid on
