# microwave-devices-lab

Coursework from the *Microwave Devices* (Dispositivos de Micro-ondas) course of the Telecommunications Engineering program at the Federal University of Santa Maria (UFSM), taught by Prof. Candice Müller.

The assignments cover the design, simulation and analysis of passive microwave circuits in Ansys HFSS, with the design calculations done in MATLAB.

## Assignments

| Assignment | Topic | What it shows |
|---|---|---|
| [Microstrip transmission line and stub matching](Microstrip%20transmission%20line%20and%20stub%20matching) | 50 Ω microstrip line on FR-4 and single-stub impedance matching at 2 GHz | Line design, S-parameters with and without dielectric loss, reflection from mismatched loads, and open and short-circuit stub matching of a complex load |
| [T-junction and Wilkinson power dividers](T-junction%20and%20Wilkinson%20power%20dividers) | Three-port microstrip power dividers at 3.5 GHz on Rogers RO4003 | Quarter-wave design, HFSS optimization with chamfers, and a comparison of matching and isolation between the two dividers |
| [Microstrip low-pass filters](Microstrip%20low-pass%20filters) | 1.9 GHz Chebyshev low-pass filters on FR-4 | Lumped prototype, Richards transform and Kuroda identities, stepped impedance of orders 3 and 7, HFSS optimization of the cutoff and a comparison of transition bands |

More assignments will be added over time.

## Topics covered

- Microstrip transmission line design
- Scattering parameters (S-parameters) and reference impedance
- Dielectric losses
- Reflection coefficient and load mismatch
- Smith chart and single-stub impedance matching
- Power dividers (T-junction and Wilkinson): insertion loss, isolation and VSWR
- Microwave filters: Chebyshev prototypes, Richards transform, Kuroda identities and stepped impedance

## Repository structure

Each assignment lives in its own folder, with a README that summarizes the method and the main results, and a `results/` folder with the full report and key figures.

The Ansys project files are not included. Each report documents the model setup and the results.

## Author

Henrique Silveira Dutra, Telecommunications Engineering student at UFSM.
[GitHub](https://github.com/henriquedutra1)
