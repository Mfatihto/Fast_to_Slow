----------------------------------------------------------------------------------
-- Company: --
-- Engineer: Mehmet Fatih Turkoglu
-- 
-- Create Date: 20.09.2024 09:34:24
-- Design Name: A basic CDC example version 2 which includes crossing from a fast clock domain to a slower domain with the pre-given input signal as well as slow frequency generic parameter.
-- Module Name: Fast_to_Slow - Behavioral
-- Project Name: CDC_Fast_to_Slow_2
-- Target Devices: --
-- Tool Versions: Vivado2022.2
-- Description: A hobby project
-- 
-- Dependencies: --
-- 
-- Revision: --
-- Revision 0.01 - File Created
-- Additional Comments: Fast clock is used as a system clock, and a slower one is derived from it using counters.
--                      This example is constructed by nandland's youtube video check here: https://www.youtube.com/watch?v=eyNU6mn_-7g
-- 
----------------------------------------------------------------------------------


library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity Fast_to_Slow is
    generic (
        SLOW_CLK_FREQ_MHZ   : integer := 10;     -- Default slow clock frequency is 25 MHz do not put bigger than Clk_Source, also make sure that 100 can be divided to it even
        FAST_CLK_FREQ_MHZ   : integer := 100     -- 100 MHz System clock which implies to Clk_Source
    );
    port (
        Clk_Source      : in std_logic;         -- 100 MHz Fast Source clock 
        Input_Signal    : in std_logic;         -- Input signal that is sampled at Source clock frequency
        Rst             : in std_logic;         -- Syncronious Active High Reset input
        Received_Sample : out std_logic         -- Captured signal from fast clock to slow clock
    );
end Fast_to_Slow;

architecture Behavioral of Fast_to_Slow is

    component CDC_FF_IP
        generic  (
            N           : integer := 2;						-- Number of flip-flops in the chain
            ASYNC_RST   : boolean := true				    -- true --> async rst, false --> sync rst
        );
        port (
            Clk : in STD_LOGIC;
            D   : in STD_LOGIC;                     -- Input of the first FF in the chain
            Q   : out STD_LOGIC;                    -- Output of the last FF in the chain
            Rst : in STD_LOGIC                      -- Reset input that resets every FF in the chain
        );
    end component;

    signal Clk_Slow             : std_logic := '1';                                       -- 25 MHz clock
    signal Clk_Cntr             : integer range 63 downto 0 := 0;                         -- Counts the rising edges of 100 MHz clock
    signal Extend_Cntr          : integer range 63 downto 0 := 0;                         -- Counter to extend the fast sample by a CLK_RATIO_2X
    signal Extend_Cntr_Enable   : std_logic := '0';   
    signal Fast_Sample          : std_logic := '0';                                       
    signal Fast_Sample_Prev     : std_logic := '0';
    signal Fast_Sample_Extended : std_logic := '0';                                       -- Extended fast sample
    constant CLK_RATIO          : integer := (FAST_CLK_FREQ_MHZ / SLOW_CLK_FREQ_MHZ);     -- Fast clock freq / Slow clock freq
    constant CLK_RATIO_1_5X     : integer := CLK_RATIO + (CLK_RATIO / 2);                 -- Fast clock freq / Slow clock freq * 1.5, gives enough extension for the slower clock to capture it, for more info check Cummings Document about CDC here: http://www.sunburst-design.com/papers/CummingsSNUG2008Boston_CDC.pdf
    signal Received_Sample_Sig  : std_logic := '0';
    signal Rst_Sig_Fast         : std_logic := '0';                                       -- Gives the syncronious Rst at every Source_Clock
    signal Rst_Sig_Slow         : std_logic := '0';                                       -- Gives the syncronious Rst at every Source_Clock

begin
    
    -- Start Input Synchronizations // REMOVE THEM IF THE UPCOMING INPUTS ARE REGISTERED !! --
    -- CDC_FF_IP is a generic ip that constructs a chain of flip-flops connected to each other, using N the number of flip-flops can be adjusted in the chain
    RST_SYNCRONIZER_FAST_DOMAIN : CDC_FF_IP
    generic map (
        N           => 2,
        ASYNC_RST   => false    -- Used as false in this example for simplicity
    )
    port map
    (
        Clk         => Clk_Source,
        D           => Rst,
        Q           => Rst_Sig_Fast,
        Rst         => '0'      -- Given '0' in this example for simplicity
    );
    --Rst_Sig_Fast <= Rst;              -- USE THIS IF INPUTS COMES AS REGISTERED

    RST_SYNCRONIZER_SLOW_DOMAIN : CDC_FF_IP
    generic map (
        N           => 2,
        ASYNC_RST   => false
    )
    port map
    (
        Clk         => Clk_Slow,
        D           => Rst,
        Q           => Rst_Sig_Slow,
        Rst         => '0'
    );
    --Rst_Sig_Slow <= Rst;              -- USE THIS IF INPUTS COMES AS REGISTERED

    INPUT_SYNCRONIZER_FAST_DOMAIN : CDC_FF_IP
    generic map (
        N           => 2,
        ASYNC_RST   => false
    )
    port map
    (
        Clk         => Clk_Source,
        D           => Input_Signal,
        Q           => Fast_Sample,
        Rst         => '0'
    );
    --Fast_Sample <= Input_Signal;      -- USE THIS IF INPUTS COMES AS REGISTERED

    -- End Input Synchronizations --

    CLK_DERIVATION_PROC : process(Clk_Source)              -- Slower clock derivation
    begin
        if(rising_edge(Clk_Source)) then
            Fast_Sample_Prev <= Fast_Sample;

            if (Clk_Cntr = (CLK_RATIO/2) - 1) then
                Clk_Slow <= not Clk_Slow;
                Clk_Cntr <= 0;
            else
                Clk_Cntr <= Clk_Cntr + 1;
            end if;
        end if;
    end process;
    
    SIGNAL_EXTENDER_PROC : process(Clk_Source, Fast_Sample, Extend_Cntr, Extend_Cntr_Enable, Fast_Sample_Prev, Rst_Sig_Fast)   -- Extend the fast sample by CLK_RATIO_2X 
    begin
        if(Rst_Sig_Fast /= '1') then
            if ((Fast_Sample_Prev = '0' and Fast_Sample = '1') and Extend_Cntr = 0) then   -- Rising-edge check on the Fast_Sample as well as make sure cntr is 0 before intiating another extended signal
                Extend_Cntr_Enable <= '1';
            end if;

            if ((rising_edge(Clk_Source) and Extend_Cntr_Enable = '1')) then
                if (Extend_Cntr = CLK_RATIO_1_5X) then
                    Fast_Sample_Extended <= '0';
                    Extend_Cntr_Enable <= '0';
                    Extend_Cntr <= 0;
                else
                    Fast_Sample_Extended <= '1';
                    Extend_Cntr <= Extend_Cntr + 1;
                end if;
            end if;
        else
            Fast_Sample_Extended <= '0';
            Extend_Cntr_Enable <= '0';
            Extend_Cntr <= 0;
        end if;
    end process;
    
    OUTPUT_SYNCRONIZER_SLOW_DOMAIN : CDC_FF_IP
    generic map (
        N           => 2,
        ASYNC_RST   => false
    )
    port map
    (
        Clk         => Clk_Slow,
        D           => Fast_Sample_Extended,
        Q           => Received_Sample,
        Rst         => Rst_Sig_Slow
    );

end Behavioral;
