# Fast_to_Slow
A VHDL implementation of a Clock Domain Crossing (CDC) example that transfers a signal from a fast clock domain to a slower clock domain. This project includes customizable parameters for the slow clock frequency and demonstrates how to safely pass signals between different clock domains in FPGA designs.

## Table of Contents

- [Overview](#overview)
- [Features](#features)
- [Project Structure](#project-structure)
- [Simulation and Synthesis](#simulation-and-synthesis)
- [Contributing](#contributing)
- [Acknowledgments](#acknowledgments)

## Overview

Clock Domain Crossing is a fundamental concept in digital design, especially when dealing with FPGAs where multiple clock domains are common. This project provides a practical example of transferring a signal from a fast clock domain (100 MHz) to a slower clock domain (configurable, default 10 MHz). It includes synchronization mechanisms to ensure data integrity across clock domains.

<!--
![CDC Diagram](assets/cdc_diagram.png)
*Note: Replace with an actual diagram if available*
-->

## Features

- **Configurable Clock Frequencies:** Easily adjust the slow clock frequency via generics.
- **Synchronization Mechanisms:** Uses a chain of flip-flops to safely transfer signals across clock domains.
- **Modular Design:** Includes reusable components for synchronization (`CDC_FF_IP`).
- **Reset Synchronization:** Synchronizes reset signals in both fast and slow clock domains.
- **Vivado Compatible:** Designed for synthesis and implementation using Xilinx Vivado 2022.2.

## Project Structure
- **Fast_to_Slow.vhd** — Top-level VHDL file
- **CDC_FF_IP.vhd** — Synchronization flip-flop chain component
- **testbench/** — Directory for testbench files
  - **testbench.vhd** — Testbench VHDL file
- **constraints/** — Constraints files (e.g., XDC files)
  - **constraints.xdc** — Example constraints file
- **scripts/** — Synthesis and simulation scripts
- **README.md** — Project documentation


