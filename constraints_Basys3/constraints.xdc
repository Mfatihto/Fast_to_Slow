##
#   Constraints file for Basys3 Board.
##

# 100 MHz Clock signal connected to Clk_Source
set_property PACKAGE_PIN W5 [get_ports Clk_Source]							
set_property IOSTANDARD LVCMOS33 [get_ports Clk_Source]
create_clock -add -name sys_clk_pin -period 10.00 -waveform {0 5} [get_ports Clk_Source]

## Rst is connected to button center BTNC
set_property PACKAGE_PIN U18 [get_ports Rst]						
set_property IOSTANDARD LVCMOS33 [get_ports Rst]

## Input_Signal is connected to button left BTNr
set_property PACKAGE_PIN T17 [get_ports Input_Signal]						
set_property IOSTANDARD LVCMOS33 [get_ports Input_Signal]

## Received_Sample is connected to LED0
set_property PACKAGE_PIN W19 [get_ports Received_Sample]					
set_property IOSTANDARD LVCMOS33 [get_ports Received_Sample]

## Virtual clock definings for I/O delays
create_clock -name virt_clk -period 10.0 

## Set input delay constraints for Rst (max and min)
set_input_delay -max 2.0 -clock virt_clk [get_ports Rst]
set_input_delay -min 0.5 -clock virt_clk [get_ports Rst]

## Set input delay constraints for Input_Signal (max and min)
set_input_delay -max 2.0 -clock virt_clk [get_ports Input_Signal]
set_input_delay -min 0.5 -clock virt_clk [get_ports Input_Signal]

## Set output delay constraints for Received_Sample (max and min)
set_output_delay -max 1.0 -clock virt_clk [get_ports Received_Sample]
set_output_delay -min 0.1 -clock virt_clk [get_ports Received_Sample]
