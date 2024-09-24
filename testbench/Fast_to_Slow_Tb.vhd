----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 20.09.2024 10:20:04
-- Design Name: 
-- Module Name: Fast_to_Slow_Tb - Behavioral
-- Project Name: 
-- Target Devices: 
-- Tool Versions: 
-- Description: 
-- 
-- Dependencies: 
-- 
-- Revision:
-- Revision 0.01 - File Created
-- Additional Comments:
-- 
----------------------------------------------------------------------------------


library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx leaf cells in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

use std.textio.all;
use std.env.finish;

entity Fast_to_Slow_Tb is
end Fast_to_Slow_Tb;

architecture sim of Fast_to_Slow_Tb is

    -- Fast_to_Slow component decleration
    component Fast_to_Slow
        generic (
            SLOW_CLK_FREQ_MHZ   : integer := 10;     -- Default slow clock frequency is 25 MHz do not put bigger than Clk_Source, also make sure that 100 can be divided to it
            FAST_CLK_FREQ_MHZ   : integer := 100     -- 100 MHz System clock which implies to Clk_Source
        );
        Port(
            Clk_Source      : in std_logic;         -- 100 MHz Source clock
            Input_Signal    : in std_logic;         -- Input signal that is sampled at Source clock frequency
            Rst             : in std_logic;         -- Syncronious Active High Reset input
            Received_Sample : out std_logic         -- Captured signal from fast clock to slow clock
        );
    end component;

    -- Signals to connect to UUT
    signal Clk_Source       : STD_LOGIC := '1';
    signal Input_Signal     : STD_LOGIC := '0';   
    signal Rst              : STD_LOGIC := '0';     
    signal Received_Sample  : STD_LOGIC := '0';

    constant clk_hz : integer := 100e6;
    constant Clk_Fast_Period : time := 1 sec / clk_hz;

begin

    Clk_Source <= not Clk_Source after Clk_Fast_Period / 2;     -- Clock generation

    DUT : Fast_to_Slow
    generic map (
            SLOW_CLK_FREQ_MHZ   => 10,     
            FAST_CLK_FREQ_MHZ   => 100     
        )
    port map (
        Clk_Source      => Clk_Source     ,         -- 100 MHz Source clock
        Input_Signal    => Input_Signal   ,         -- Input signal that is sampled at Source clock frequency
        Rst             => Rst            ,         -- Syncronious Active High Reset input
        Received_Sample => Received_Sample         -- Captured signal from fast clock to slow clock
    );

    SEQUENCER_PROC : process
    begin
        wait for Clk_Fast_Period * 2;

        Rst <= '1';
        
        wait for Clk_Fast_Period * 2;
        
        Rst <= '0';
        
        wait for Clk_Fast_Period * 2;
        
        wait until rising_edge(Clk_Source);
        Input_Signal <= '1';
        wait until rising_edge(Clk_Source);
        Input_Signal <= '0';


        wait for Clk_Fast_Period * 20;
        
        Rst <= '1';
        
        wait for Clk_Fast_Period * 50;
        assert false
            report "Replace this with your test cases"
            severity failure;

        finish;
    end process;

end architecture;
