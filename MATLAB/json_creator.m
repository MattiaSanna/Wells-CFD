%Assegnare variabili con i dati dal file

info



load('Measurements/experimental.mat');

%load the experimental data

piston_vel     = test.data(:,3);
air_velocity        = test.data(:,4);
deltaP          = test.data(:,6);
omega_rpm       = test.data(:,7);
omega = (omega_rpm) * 2*pi  / (60);
torque_aero     = test.data(:,9);
time            = test.data(:,1);


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

efficiency = (torque_aero .* omega) ./ (deltaP .* Q);

%U at the avergae blade span
U_aver = 2 * pi * r_med * omega_rpm / 60;




%lets plot

figure(1)
plot(flow_coef , torque_coef, 'o', 'MarkerFaceColor', red, 'MarkerEdgeColor', red, 'MarkerSize', marker_size)
xlabel('Flow coefficient  $\phi^{*}$', 'Interpreter', 'latex', 'FontSize', font_axis)
ylabel('Torque coefficient $T^{*}$', 'Interpreter', 'latex', 'FontSize', font_axis)
xlim([-0.4 0.4]);
grid on
hold on;


figure(2)
plot(flow_coef ,press_coef, 'o', 'MarkerFaceColor', red, 'MarkerEdgeColor', red, 'MarkerSize', marker_size)
xlabel('Flow coefficient  $\phi^{*}$', 'Interpreter', 'latex', 'FontSize', font_axis)
ylabel('Pressure coefficient $p^{*}$', 'Interpreter', 'latex', 'FontSize', font_axis)
xlim([-0.4 0.4]);
grid on
hold on;

figure(3)
plot(flow_coef, efficiency, 'o', 'MarkerFaceColor', red, 'MarkerEdgeColor', red, 'MarkerSize', marker_size)
xlabel('Flow coefficient  $\phi^{*}$', 'Interpreter', 'latex', 'FontSize', font_axis)
ylabel('Efficiency $\eta$', 'Interpreter', 'latex', 'FontSize', font_axis)
ylim([0 1]);
xlim([-0.4 0.4]);
grid on
hold on;

%Assegnare variabili con i dati dal file

info




% 1. Pack the data (sampling every 10th value)
file = struct();
file.flowCoefficient   = flow_coef(1:10:end);
file.torqueCoefficient = torque_coef(1:10:end);
file.pressureCoefficient = press_coef(1:10:end);
file.efficiency    = efficiency(1:10:end);


% For Octave / older MATLAB versions:
jsonString = jsonencode(file);

% 3. Save to disk
fid = fopen('experimental.json', 'w');
fprintf(fid, '%s', jsonString);
fclose(fid);






load('Measurements/CFD.mat');

%Assegnare variabili con i dati dal file

r_med=0.11
h=0.03
radius_tip=0.125
rho = test.rho;
At = 2 * pi * r_med * h ;



%load the experimental data

piston_vel      = test.data(:,3);
air_velocity    = test.data(:,4);
deltaP          = test.data(:,6);
omega_rpm       = test.data(:,7);
omega           = (omega_rpm) * 2*pi  / (60);
torque_aero     = test.data(:,9)+0.025;
time            = test.data(:,1);
Cz              = test.data(:,4);


%portata

Q=Cz*At

%definire coef adimensionali

flow_coef = Cz ./ (omega .* radius_tip);

torque_coef = torque_aero ./ (rho .* (omega).^2 .* radius_tip^5);

press_coef = deltaP ./ (rho .* (omega).^2 * radius_tip.^2);

efficiency = (torque_aero .* omega) ./ (deltaP .* Q);




%lets plot


figure(1)
plot(flow_coef , torque_coef, 'o', 'MarkerFaceColor', cyano, 'MarkerEdgeColor', cyano, 'MarkerSize', marker_size)
xlabel('Flow Coefficient \phi^*')
ylabel('Torque Coefficient T^*')
ylim([-0.005 0.1]);
xlim([-0.3 0.3]);

grid on

axis square  % or pbaspect([1 1 1])
%set(gcf, 'Position', [100, 100, 500, 500])  % square window




figure(2)
plot(flow_coef ,press_coef, 'o', 'MarkerFaceColor', cyano, 'MarkerEdgeColor', cyano, 'MarkerSize', marker_size)
xlabel('Flow Coefficient \phi^*')
ylabel('Pressure Coefficient p^*')
grid on
xlim([-0.3 0.3]);

axis square  % or pbaspect([1 1 1])

%set(gcf, 'Position', [100, 100, 500, 500])  % square window





figure(3)
plot(flow_coef, efficiency, 'o', 'MarkerFaceColor', cyano, 'MarkerEdgeColor', cyano, 'MarkerSize', marker_size)
xlabel('Flow Coefficient \phi^*')
ylabel('Efficiency \eta')
ylim([0 1]);
xlim([-0.25 0.25]);
grid on

axis square  % or pbaspect([1 1 1])


% 1. Pack the data (sampling every 10th value)
file = struct();
file.flowCoefficient   = flow_coef;
file.torqueCoefficient = torque_coef;
file.pressureCoefficient = press_coef;
file.efficiency    = efficiency;


% For Octave / older MATLAB versions:
jsonString = jsonencode(file);

% 3. Save to disk
fid = fopen('cfd.json', 'w');
fprintf(fid, '%s', jsonString);
fclose(fid);

