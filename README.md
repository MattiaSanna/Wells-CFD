# Wells Turbine CFD Analysis

## 1. Project Overview

This project is a numerical replication of experimental Wells turbine performance, based on my bachelor thesis *The Effect of Solidity on Wells Turbine Performance*.

A single configuration from the experimental campaign was selected. The same turbine geometry, rotational speed, inlet conditions and fluid properties were implemented in ANSYS Fluent using a steady Multiple Reference Frame (MRF) approach.

**Results.** Over the simulated range, the CFD torque and pressure coefficients agree with the experiment with a mean absolute relative error of **16.1 %** and **8.4 %** respectively (φ = 0 and points where the experimental value is below 10 % of its peak are excluded). See [Comparison with Experiment](#9-comparison-with-experiment) for the definition of the metric and the limits of the comparison.

**Scope.** Only one configuration (6 blades, solidity 0.625) was simulated, while the thesis compared five (4 to 8 blades) to study the effect of solidity. This project therefore tests whether CFD can reproduce the performance of a single turbine. It does not show that CFD captures the solidity trend, which would require at least a second configuration.

[View the CFD project on the website](https://wells.serben-di-pupo.com)

## 2. Project Objectives and Methodology

The numerical investigation was divided into these stages:

1. CAD reconstruction of the experimental turbine.
2. Computational domain development using a Multiple Reference Frame approach.
3. Mesh generation and near-wall refinement.
4. Definition of the physical models and boundary conditions.
5. Numerical verification (mesh independence, y+, convergence, mass balance).
6. Post-processing of the aerodynamic quantities.
7. Comparison with the experimental performance data.

The quantities compared with the experiment are the torque coefficient, the pressure coefficient and the turbine efficiency, plus the dimensional torque and pressure drop.

## 3. CAD Model and Airfoil Generation

The geometry was reconstructed from the dimensions reported in the experimental investigation. A Python script generates the NACA 0015 symmetrical airfoil profile mathematically, and the coordinates were then exported for the CAD reconstruction. This avoids relying on manually drawn profiles.

| Parameter | Value |
|---|---:|
| Airfoil | NACA 0015 |
| Blade count Z | 6 |
| Chord length c | 72 mm |
| Tip radius R<sub>t</sub> | 125 mm |
| Hub radius R<sub>h</sub> | 95 mm |
| Hub-to-tip ratio | 0.76 |
| Mean radius r<sub>mean</sub> | 110 mm |
| Solidity σ = Zc / (2π r<sub>mean</sub>) | 0.625 |

## 4. Computational Domain — Multiple Reference Frame

### 4.1 Domain architecture

The domain is divided into three regions, all lengths being expressed in blade chords (c = 72 mm):

| Domain | Frame | Axial length |
|---|---|---|
| Inlet duct | Stationary | 3 chords (216 mm) |
| Rotor region | Rotating (MRF) | 2 chords (144 mm) |
| Outlet duct | Stationary | 5 chords (360 mm) |

A tip clearance of 1 mm was modelled between the blade tips and the casing. Because the casing is stationary in the absolute frame, its wall was set to zero absolute rotational speed inside the rotating zone.

### 4.2 Multiple Reference Frame (MRF)

A steady MRF formulation represents the rotating turbine. The governing equations are solved in different reference frames within the same computational domain: the rotor region is assigned a rotating reference frame, while the inlet and outlet regions remain stationary. Rotational effects are therefore included in a steady-state simulation without moving the mesh. The approach is widely used in turbomachinery because it greatly simplifies the modelling of rotating machinery.

### 4.3 Rotational periodicity

Only a single-blade sector was simulated. For a six-blade rotor the sector angle is 360° / 6 = **60°**. Rotational periodic boundary conditions were applied to the two circumferential faces, so the model represents the full rotor under the assumption that all blade passages behave identically. This holds well in attached flow but becomes less reliable if stall introduces asymmetric or unsteady separation.

## 5. Mesh Generation

An unstructured hybrid mesh was generated, with local refinement around the blades and inflation layers to resolve the boundary layer:

- 15 inflation layers
- Growth rate of 1.2
- Target y+ ≈ 1

Three mesh resolutions, from about 330 thousand to 1 million cells, were used for the mesh independence study described in [Numerical Verification](#7-numerical-verification).

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

## 7. Numerical Verification

Verification checks whether the equations are solved correctly. It is separate from the comparison with experiment (Section 9), which is the validation step.

### 7.1 Mesh independence

The study was carried out at the peak-efficiency operating point, φ = 0.15 (attached flow).

| Mesh | Elements [k] | Torque [N·m] | Change relative to the finest mesh |
|---|---:|---:|---:|
| Coarse | 333 | 0.2816 | 3.13 % |
| Fine (selected) | 880 | 0.2908 | 0.058 % |
| Very fine | 1041 | 0.2907 | – |

The convergence is slightly non-monotonic (torque rises from coarse to fine, then drops marginally), so the observed order of convergence and a Richardson extrapolation cannot be reliably computed. A conservative Grid Convergence Index, assuming second-order convergence (p = 2, safety factor 3), gives about **1.5 %** on the finest mesh. This is much smaller than the 16.1 % deviation from the experiment, so the discretisation error cannot explain the deviation. The estimate was made at a single operating point in attached flow.

### 7.2 Near-wall resolution

Fifteen inflation layers were generated along the blade surface to resolve the boundary layer with y+ ≈ 1. The y+ distribution on the blade is shown in `Pics/`.

<!-- TODO: add the area-averaged and maximum y+ and the first-layer height here. -->

### 7.3 Convergence and mass balance

Residuals were monitored until they fell below 1e-4, together with the torque and the mass imbalance. At the inlet and outlet the net mass flow of the sector is 2.97 × 10⁻⁶ kg/s out of 0.0377 kg/s, an imbalance of about **0.008 %**.

## 8. Post-Processing and Data Pipeline

Each steady case was solved in Fluent, and the results were transcribed into a Python script that generates the `.mat` files used by MATLAB. The MATLAB scripts (in `MATLAB/`) then compute the flow coefficient, pressure coefficient, torque coefficient and aerodynamic efficiency of both the CFD and the experiment, and compare them.

<!-- TODO: state whether the sector torque is multiplied by 6 to obtain the full-rotor torque, and which surfaces and pressure type (static, area-weighted) were used for the pressure drop. -->

## 9. Comparison with Experiment

CFD predictions were compared point by point with the experimental data of the reference thesis. The experimental curves were linearly interpolated at the CFD operating points, and the relative error was computed as (CFD − Exp) / Exp. The point φ = 0 and points where the experimental value is below 10 % of its peak were excluded, because the relative error is not meaningful there.

| Quantity | Mean absolute relative error |
|---|---:|
| Torque coefficient | 16.1 % |
| Pressure coefficient | 8.4 % |

<!-- TODO: add columns/rows once computed with the same code:
     max error and the φ where it occurs; torque split pre-stall (φ < 0.21) / post-stall (φ ≥ 0.21); efficiency.
     Then add the figure: ![Torque coefficient: CFD vs experiment](Results/torque_comparison.png) -->

**Torque offset.** The experimental torque is corrected for windage and friction losses, so it is zero at zero flow. The CFD torque is not: at 0 m/s and 3600 rpm it gives −0.03 N·m, due to the aerodynamic drag of the rotating blades in still air. To compare like with like, a constant offset of 0.03 N·m was added to the CFD torque so that both curves pass through zero at zero flow:

```matlab
torque_aero = test.data(:,9) + 0.03;
```

The offset is a single-point correction at zero flow, so agreement at φ = 0 is imposed and that point is excluded from the error statistics. It is assumed constant because the rotational speed is fixed at 3600 rpm.

<!-- TODO: add "Without the offset, the mean torque error would be X % instead of 16.1 %." -->

**Limits of the comparison.** The comparison covers a single configuration and does not include experimental uncertainty bands, so it shows agreement within the stated errors and is not a general validation of the model.

## 10. Limitations and Future Work

**Stall and steady-state modelling.** The simulations are steady RANS. MRF suits this geometry because there are no stationary blade rows, so the main limitation of the steady assumption is separated flow. The turbine stalls at φ ≈ 0.21 and several simulated points lie beyond it. Post-stall separation on the suction side is unsteady and three-dimensional, and a steady solution can only approximate its time-averaged effect, so predictions in that range are less reliable.

**Turbulence and transition.** At 3600 rpm the chord Reynolds number is about 2 × 10⁵, where laminar separation bubbles and laminar-turbulent transition can influence where the flow separates. The SST k-ω model is fully turbulent and cannot capture transition, which may shift the predicted stall onset.

**Periodicity.** The 60° sector assumes identical flow in every blade passage, which may not hold in stalled flow.

**Mesh verification.** The mesh study was done at one attached-flow point and not repeated post-stall. The refinement ratio between the two finest meshes is small (about 1.06), so the GCI is only a conservative estimate.

**Experimental reference and offset.** Experimental uncertainty is not included in the comparison. The torque comparison also depends on the constant 0.03 N·m offset, which is not negligible next to the torque at the peak-efficiency point (about 0.29 N·m).

**Future work**

- Simulate a second configuration (4 or 8 blades, i.e. 90° or 45° sectors) to test whether CFD reproduces the solidity trend.
- Add a transition model, and a transient simulation for the post-stall points.
- Repeat the mesh study in the stalled regime with a larger refinement ratio and compute a full GCI.
- Automate the Fluent sweep and the export of the results (journal file), replacing the manual transcription.

<!-- TODO (optional, strongly recommended): add a "Flow field" section with mid-span pressure and relative-velocity contours at pre-stall and post-stall φ. -->

## Repository Structure

| Folder | Content |
|---|---|
| `Ansys/` | Fluent and DesignModeler files |
| `CAD/` | Geometry files |
| `MATLAB/` | Post-processing and comparison scripts |
| `Pics/` | Figures (mesh, y+, convergence, domain) |
| `Results/` | Comparison plots |

## Software

- ANSYS Fluent
- ANSYS DesignModeler
- Python
- MATLAB
- SolidWorks
