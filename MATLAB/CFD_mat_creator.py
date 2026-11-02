import numpy as np
from scipy.io import savemat


single_blade = True


vel = [1.5, 3, 4.5, 6, 7.5, 9, 10.5, 11, 11.5, 12]
torque = [-0.0027740665,-0.0004532749, 0.0068164424, 0.017959818, 0.032173242, 0.048772873,  0.067919503, 0.069693812, 0.033439293,0.030822233]
deltaP = [75.8533034,292.30379, 549.57754, 795.32506, 1040.40294, 1281.8899, 1529.7685, 1577.9643, 1688.04469,1783.89003]



vel_neg = []

deltaP_neg = []

for speed in vel:
    vel_neg.append(-speed)
    
for press in deltaP:
    deltaP_neg.append(-press)

vel_neg = list(reversed(vel_neg)) 
deltaP_neg = list(reversed(deltaP_neg)) 

vel = vel_neg + vel
deltaP = deltaP_neg + deltaP

torque =  list(reversed(torque))  + torque
torque_full = []

if single_blade ==True:
    for t in torque:
        torque_full += [t*6]
        


empty1 = np.full(len(vel), np.nan)
empty2 = np.full(len(vel), np.nan)
empty3 = np.full(len(vel), np.nan)

empty5 = np.full(len(vel), np.nan)
empty6 = np.full(len(vel), np.nan)
omega = np.full(len(vel), 4000)
empty8 = np.full(len(vel), np.nan)

data = np.column_stack((
    
    empty1,
    empty2,
    empty3,
    vel,
    empty5,
    deltaP,
    omega,
    empty8,
    torque_full
))

savemat("Measurements/CFD.mat", {
    "test": {
        "data": data,
        "rho": 1.1685
        
    }
})