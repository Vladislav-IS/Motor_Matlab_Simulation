# Motor Matlab Simulation

This repository is used for experiments with Simulink induction motor models.

## Repository Layout

```
├── dataset/                        # Raw measurements and metadata (real induction motors)
│   ├── engine_1/                   # First motor dataset (see `dataset/engine_1/README.md`)
│   └── engine_2/                   # Second motor dataset (see `dataset/engine_2/README.md`)
├── training_configs/               # YAML files describing training parameters
├── AC_motor_4.slx                  # Simulink induction motor model (previous version)
├── AC_motor_5.slx                  # Simulink induction motor model (the newest version)
├── AIR_Series.pdf                  # Operation manual containing info about various AIR motors 
├── AIR_Series.csv                  # Tabular info about various AIR motors
├── AIR_Generation.m                # Matlab script for launching the grid simulation
├── Calculate_Basic.m               # Matlab script containing basic motor parameters calculations
├── Run_Simulation.m                # Matlab script for launching the single engine simulation
├── Run_Healthy_Simulation.m        # Matlab script for launching the simulation without faults
├── Run_Short_Circuit_Simulation.m  # Matlab script for launching the simulation with inter-turn short circuits
├── Run_Broken_Rods_Simulation.m    # Matlab script for launching the simulation with rotor bar defect
├── Find_Best_Noizz.m               # Matlab script for launching the simulation in order to find the best noise constant 
├── Calculation_005_AIR80B4.xcmd    # Mathcad file for model parameters calculations
├── Screening.ipynb                 # IPython notebook for drawing spectra (by phase)
├── Results.ipynb                   # IPython notebook for drawing spectra (by state)
└── Noizz_Parameter_Search.ipynb    # IPython notebook for searching for the best noise constant
```

## 1. Search for the best noise constant

The main idea of this project stage is to calculate statistical characteristics array (means and STDs) for frequencies in real signal spectrum and then to minimize mean absolute error (MAE) between arrays 
associated with real and simulated signals using Bayesian optimization (Optuna).

__Results:__
- minimal MAE for means was obtained for the noise constant `Noizz = 0.048`;
- minimal MAE for STDs was obtained for the noise constant `Noizz = 19.779`.

Spectra for the obtained `Noizz` values (phase 1) are shown below.

<img width="989" height="490" alt="image" src="https://github.com/user-attachments/assets/c7736aa1-bc78-49c3-9449-a74557293bec" />

<img width="989" height="490" alt="image" src="https://github.com/user-attachments/assets/d7545c59-1424-468c-a516-a4976c691f02" />

