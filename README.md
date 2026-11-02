# Wells Turbine CFD Analysis

## 1. Project Overview

This project focuses on the numerical replication of experimental Wells turbine performance, based on my bachelor thesis *The Effect of Solidity on Wells Turbine Performance*.

A single configuration from the experimental campaign was selected for numerical replication. The same turbine geometry, rotational speed, inlet conditions and fluid properties were implemented in ANSYS Fluent using a steady Multiple Reference Frame (MRF) approach. 

The final results showed variation from 5% to 10% for the torque, 1% to 3% for pressure delta and 8 to 14 for the aerodynamic efficiency.


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

A steady Multiple Reference Frame formulation was selected to represent the rotating turbine.

In this approach, the governing equations are solved in different reference frames within the same computational domain.

The rotor region is assigned a rotating reference frame, while the inlet and outlet regions remain stationary.

This allows rotational effects to be included in a steady-state simulation without explicitly moving the mesh at every time step.

This approach is widely used in turbomachinery simulations and allows to simplify themodelling of rotating turbomachinery.

### 4.3 Rotational Periodicity

To reduce computational requirements, the complete rotor was not simulated.

Instead, a single-blade sector was considered.

For a six-blade rotor, the angular sector is 60°.

Periodic boundary conditions were applied to the two circumferential faces of the sector.

This allows the numerical model to represent the complete rotor under the assumption of rotational periodicity.


## 5. Mesh Generation

An unstructured hybrid mesh was generated, with local refinement around the blades and inflation layers to resolve the boundary layer.

The mesh included:
- 15 inflation layers
- Growth rate of 1.2
- Target y+ ≈ 1

A grid independence study was also performed using four mesh resolutions, ranging from 200 thousand to 1 million cells.

## 6. CFD Setup

The simulations were performed in **ANSYS Fluent** using:
- Pressure-based, steady-state solver
- SST \(k-\omega\) turbulence model
- Multiple Reference Frame (MRF)
- Velocity inlet and pressure outlet
- No-slip blade walls
- Second-order spatial discretisation

The MRF approach allowed the rotating turbine to be simulated within a stationary computational domain.

## 7. Post-Processing and MATLAB Analysis

Fluent results were exported for further analysis in MATLAB using Python scripts for the generation of the .mat files.

The post-processing workflow calculated:
- Flow coefficient
- Pressure coefficient
- Torque coefficient
- Aerodynamic efficiency

Numerical results were then compared with experimental measurements to evaluate the accuracy of the CFD model.

## Model Validation

The numerical model was validated by comparing CFD predictions against the experimental results reported in the reference thesis through MATLAB plots.

Validation focused on:
- **Torque, pressure drop and efficiency:** comparing simulated and experimental torque across different inlet velocities.
- **Flow behaviour:** examining pressure and velocity distributions around the blades to verify that the simulated aerodynamic behaviour was physically consistent.

Residual convergence and the stability of monitored quantities were checked to evaluate numerical convergence.

The comparison highlighted differences between CFD predictions and experimental measurements, providing a basis for assessing the limitations of the numerical setup and identifying areas for further improvement.

**Note.**

For the torque plots, the experimental data detracted the windage and friction losses, as quoted into the Thesis work. For this reason a small coefficient of 0.025Nm was taking into account into the final CFD results:

torque_aero     = test.data(:,9)+0.025;

## Softwares

- ANSYS Fluent
- ANSYS DesignMdoler
- Python
- MATLAB
- SolidWorks
