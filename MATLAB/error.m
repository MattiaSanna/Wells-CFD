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

efficency = (torque_aero .* omega) ./ (deltaP .* Q);

%U at the avergae blade span
U_aver = 2 * pi * r_med * omega_rpm / 60;









info


load('Measurements/CFD.mat');

%Assegnare variabili con i dati dal file

r_med=0.11
h=0.03
radius_tip=0.125
rho = test.rho;
At = 2 * pi * r_med * h ;



%load the experimental data

piston_vel_CFD      = test.data(:,3);
air_velocity_CFD    = test.data(:,4);
deltaP_CFD          = test.data(:,6);
omega_rpm_CFD       = test.data(:,7);
omega_CFD           = (omega_rpm_CFD) * 2*pi  / (60);
torque_aero_CFD     = test.data(:,9)+0.03;
time_CFD            = test.data(:,1);
Cz_CFD              = test.data(:,4);


%portata

Q_CFD=Cz_CFD*At;

%definire coef adimensionali

flow_coef_CFD = Cz_CFD ./ (omega_CFD .* radius_tip);

torque_coef_CFD = torque_aero_CFD ./ (rho .* (omega_CFD).^2 .* radius_tip^5);

press_coef_CFD = deltaP_CFD ./ (rho .* (omega_CFD).^2 * radius_tip.^2);

efficiency_CFD = (torque_aero_CFD .* omega_CFD) ./ (deltaP_CFD .* Q_CFD);


%interpolate cause we have less CFD points than exp points


torque_coef_int = interp1(flow_coef, torque_coef, flow_coef_CFD, 'linear');
T_err = ((torque_coef_CFD-torque_coef_int)./torque_coef_int).*100;


valid = abs(torque_coef_int) > 0.10 * max(abs(torque_coef_int));
MAPE = mean(abs(T_err(valid)))



