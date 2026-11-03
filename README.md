# Wells Turbine CFD Analysis

## 1. Project Overview

This project focuses on the numerical replication of experimental Wells turbine performance, based on my bachelor thesis *The Effect of Solidity on Wells Turbine Performance*.

**Scope.** Only one turbine configuration (6 blades, solidity 0.625) was simulated. The original thesis compared five configurations (4 to 8 blades) to study the effect of solidity. This project therefore tests whether CFD can reproduce the performance of a single turbine. It does not show that CFD captures the solidity trend, which would require at least a second configuration.

The torque coefficient predicted by CFD agrees with the experiment with a mean absolute relative error of **16 %** over the evaluated range, as expected for a steady RANS model.


[View the CFD project on the website](https://wells.serben-di-pupo.com)


## 2. Project Objectives and Methodology

The numerical investigation was divided into several stages:

1. CAD reconstruction of the experimental turbine.
2. Computational domain development using a Multiple Reference Frame approach.
3. Mesh generation and near-wall refinement.
4. Definition of the physical models and boundary conditions.
5. Numerical quality assessment and mesh independence.
6. Post-processing of aerodynamic quantities.
7. Comparison against experimental performance data.

The main performance quantities used for comparison were:

- Aerodynamic torque.
- Pressure drop.
- Non-dimensional pressure coefficient.
- Non-dimensional torque coefficient.
- Turbine efficiency.
## 3. CAD Model and Airfoil Generation

The turbine geometry was reconstructed using the dimensions and geometric characteristics reported in the experimental investigation.

Python was used to generate the right airfoil profile mathematically starting from the **NACA 0015 symmetrical airfoil** coordinates, later  exported for CAD reconstruction.

This approach ensured an accurate airfoil geometry instead of relying on manually drawn profiles.

The main geometric parameters considered during reconstruction were:

| Parameter | Value |
|---|---:|
| Airfoil | NACA 0015 |
| Blade count | 6 |
| Chord length | 72 mm |
| Solidity | 0.625 |
| Tip radius | 125 mm* |
| Hub radius | 95 mm* |
| Hub-to-tip ratio | 0.76* |

## 4. Computational Domain — Multiple Reference Frame

### 4.1 Domain Architecture

The computational domain was divided into three regions:
- Upstream stationary duct
- Rotating region containing the turbine
- Downstream stationary duct

A **60° periodic sector** was used to model a single blade passage, reducing computational cost while preserving the turbine's rotational symmetry.

### 4.2 Multiple Reference Frame (MRF)

A steady Multiple Reference Frame (MRF) formulation was selected to represent the rotating turbine.

The governing equations are solved in different reference frames within the same computational domain. The rotor region is assigned a rotating reference frame, while the inlet and outlet regions remain stationary. This allows rotational effects to be included in a steady-state simulation without moving the mesh at every time step. The approach is widely used in turbomachinery simulations because it greatly simplifies the modelling of rotating machinery.

| Domain | Frame | Axial length |
|---|---|---|
| Inlet duct | Stationary | 3 chords (216 mm) |
| Rotor region | Rotating (MRF) | 2 chords (144 mm) |
| Outlet duct | Stationary | 5 chords (360 mm) |

A tip clearance of 1 mm was modelled between the blade tips and the casing. Because the casing is stationary in the absolute frame, its wall was set to zero absolute rotational speed inside the rotating zone.

### 4.3 Rotational Periodicity

To reduce computational requirements, only a single-blade sector of the rotor was simulated.

For a six-blade rotor the sector angle is 360°/6 = 60°. Rotational periodic boundary conditions were applied to the two circumferential faces of the sector, so the model represents the full rotor under the assumption that all blade passages behave identically. This assumption holds well in attached flow but becomes less reliable when stall introduces asymmetric or unsteady separation.

## 5. Mesh Generation

An unstructured hybrid mesh was generated, with local refinement around the blades and inflation layers to resolve the boundary layer.

The mesh included:
- 15 inflation layers
- Growth rate of 1.2
- Target y+ ≈ 1

A grid independence study was also performed using four mesh resolutions, ranging from 330 thousand to 1 million cells.

## 6. CFD Setup

The simulations were performed in **ANSYS Fluent** using:
- Pressure-based, steady-state solver
- SST \(k-\omega\) turbulence model
- Multiple Reference Frame (MRF)
- Velocity inlet and pressure outlet
- No-slip blade walls
- Second-order spatial discretisation

The MRF approach allowed the rotating turbine to be simulated within a stationary computational domain.

The exact boundary conditions of the experimental tests were replicated:
## 6. CFD Setup

The simulations were performed in **ANSYS Fluent**. The boundary conditions replicate the experimental tests.

| Category | Setting | Value |
|---|---|---|
| **Solver** | Type | Pressure-based, steady-state |
| | Pressure-velocity coupling | Coupled |
| | Spatial discretisation | Second-order upwind (momentum, k, ω) |
| **Turbulence** | Model | SST k-ω |
| | Turbulence specification | Intensity and viscosity ratio |
| | Turbulent intensity (inlet and outlet) | 2 % |
| | Turbulent viscosity ratio (inlet and outlet) | 7 |
| **Rotation** | Rotational speed | 3600 rpm (≈ 377 rad/s) |
| | Rotating zone | MRF, 2 chords long (144 mm) |
| | Interface | MRF with mesh interface |
| | Domain sector | 60° rotational periodicity |
| **Domain** | Inlet duct | 3 chords (216 mm), stationary |
| | Outlet duct | 5 chords (360 mm), stationary |
| | Tip clearance | 1 mm |
| **Boundaries** | Inlet | Velocity inlet, 0–12 m/s |
| | Outlet | Pressure outlet, 0 Pa gauge |
| | Blade, hub | No-slip, rotating with the frame |
| | Casing | No-slip, stationary in the absolute frame |
| **Fluid (air)** | Density | 1.1685 kg/m³ (constant) |
| | Dynamic viscosity | 1.854 × 10⁻⁵ Pa·s |
| **Convergence** | Residual criterion | 1e-4 |
| | Monitored quantities | Torque, mass imbalance |

Fluent results were exported for further analysis in MATLAB using Python scripts for the generation of the .mat files.

The post-processing workflow calculated:
- Flow coefficient
- Pressure coefficient
- Torque coefficient
- Aerodynamic efficiency

Numerical results were then compared with experimental measurements to evaluate the accuracy of the CFD model.

## Model Validation

The numerical model was validated by comparing CFD predictions against the experimental results reported in the reference thesis through MATLAB plots and exported into the Results folder in the repository. 

Validation focused on:
- **Torque, pressure drop and efficiency:** comparing simulated and experimental torque across different inlet velocities.
- **Flow behaviour:** examining pressure and velocity distributions around the blades to verify that the simulated aerodynamic behaviour was physically consistent.

Residual convergence and the stability of monitored quantities were checked to evaluate numerical convergence.

The comparison highlighted differences between CFD predictions and experimental measurements, providing a basis for assessing the limitations of the numerical setup and identifying areas for further improvement.

**Note on the torque comparison.** The experimental torque is corrected for windage and friction losses, so it is zero at zero flow. The CFD torque is not: at 0 m/s and 3600 rpm it gives −0.03 N·m, due to the aerodynamic drag of the rotating blades in still air. To compare like with like, a constant offset of 0.03 N·m was added to the CFD torque so that both curves pass through zero at zero flow:

`torque_aero = test.data(:,9) + 0.03;`

The offset was kept constant because the rotational speed was fixed at 3600 rpm. It is a single-point correction at zero flow, so agreement at φ = 0 is imposed and that point is excluded from the error statistics. Without the offset, the mean torque error would be X% instead of Y%.

## Softwares

- ANSYS Fluent
- ANSYS DesignMdoler
- Python
- MATLAB
- SolidWorks
