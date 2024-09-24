# Fast_to_Slow_CDC
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

## Simulation and Synthesis

### 1. Simulation

- **Testbench Files:** Use the testbench files located in the `testbench/` directory to simulate the design.
- **Simulator:** Run the simulation using Vivado's built-in simulator or any other VHDL-compatible simulator like ModelSim or GHDL.
- **Steps:**
  1. **Open Your Simulator:** Launch your preferred VHDL simulator.
  2. **Add VHDL Files:** Include `Fast_to_Slow.vhd`, `CDC_FF_IP.vhd`, and the testbench VHDL file.
  3. **Compile the Design:** Ensure all files compile without errors.
  4. **Run the Simulation:** Execute the simulation and observe the waveforms.
  5. **Verify Functionality:** Check that the signal is correctly transferred from the fast clock domain to the slow clock domain.

### 2. Synthesis

- **Vivado Project:**
  - Ensure all VHDL source files are added to your Vivado project.
  - Set `Fast_to_Slow.vhd` as the top module.

- **Constraints:**
  - Add the appropriate constraints file (`constraints.xdc`) from the `constraints/` directory.
  - Specify clock frequencies and pin assignments according to your FPGA board.

- **Steps:**
  1. **Run Synthesis:**
     - In Vivado, click on **Run Synthesis**.
     - Wait for the synthesis process to complete.
  2. **Review Synthesis Results:**
     - Check for any warnings or errors.
     - Ensure that the design meets the synthesis criteria.
  3. **Run Implementation:**
     - Click on **Run Implementation**.
     - Wait for placement and routing to complete.
  4. **Timing Analysis:**
     - Open the **Timing Summary** report.
     - Verify that there are no timing violations, especially in the clock domain crossing paths.
  5. **Generate Bitstream (Optional):**
     - If you're planning to program the FPGA, click on **Generate Bitstream**.

### 3. Programming the FPGA (Optional)

- **Hardware Setup:**
  - Connect your FPGA development board to your computer via USB or JTAG.

- **Programming Steps:**
  1. **Open Hardware Manager:**
     - In Vivado, go to **Flow Navigator** > **Program and Debug** > **Open Hardware Manager**.
  2. **Connect to the Target:**
     - Click on **Open Target** > **Auto Connect**.
     - Vivado should detect your FPGA device.
  3. **Program the Device:**
     - Right-click on the device and select **Program Device**.
     - Choose the generated bitstream file (`.bit`) and click **Program**.
  4. **Verification:**
     - After programming, test the design to ensure it functions as expected.

---

**Note:** Ensure that your FPGA board supports the required clock frequencies and that all pin assignments in the constraints file match your hardware configuration.




