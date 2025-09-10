# Motor Matlab Simulation

This repository is used for experiments with Simulink induction motor models.

## Repository Layout

```
├── dataset/              # Raw measurements and metadata (real induction motors)
│   ├── engine_1/         # First motor dataset (see `dataset/engine_1/README.md`)
│   └── engine_2/         # Second motor dataset (see `dataset/engine_2/README.md`)
├── training_configs/     # YAML files describing training parameters
├── AC_motor_4.slx        # Simulink induction motor model
├── AIR_Series.pdf        # Operation manual containing info about various AIR motors 
├── Find_Best_Noizz.m     # Matlab script for launching the simulation
└── Model_Analysis.ipynb  # IPython notebook for searching for the best noise constant
```

## 1. Search for the best noise constant

The main idea of this project stage is to calculate statistical characteristics array (means and STDs) for frequencies in real signal spectrum and then to minimize mean absolute error (MAE) between arrays 
associated with real and simulated signals using Bayesian optimization (Optuna).

__Results:__
- minimal MAE for means obtained for the noise constant `Noizz = 0.048`;
- minimal MAE for STDs obtained for thr noise constant `Noizz = 19.779`.

Spectra for the obtained `Noizz` values (phase 1) are shown below.

<img width="989" height="490" alt="image" src="https://github.com/user-attachments/assets/c7736aa1-bc78-49c3-9449-a74557293bec" />

<img width="989" height="490" alt="image" src="https://github.com/user-attachments/assets/d7545c59-1424-468c-a516-a4976c691f02" />
