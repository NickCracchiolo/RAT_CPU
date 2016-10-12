----------------------------------------------------------------------------------
-- Company: Cal Poly
-- Engineer: Nick Cracchiolo
-- 
-- Create Date: 02/22/2016 05:35:38 PM
-- Design Name: SmallMUX
-- Module Name: SmallMux - Behavioral
-- Project Name: Experiment 9
-- Target Devices: Basys3
-- Tool Versions: Vivado 2014.4
-- Description: 2 input MUX built for the C and Z flag components
-- Has a two bit selector to adhere to control unit
-- Dependencies: 
-- 
-- Revision:
-- Revision 0.01 - File Created
-- Additional Comments:
-- 
----------------------------------------------------------------------------------
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity SmallMux is
    Port ( IN0  : in STD_LOGIC;
           IN1  : in STD_LOGIC;
           SEL  : in STD_LOGIC;
           DOUT : out STD_LOGIC);
end SmallMux;

architecture Behavioral of SmallMux is

signal temp_din : std_logic := '0';

begin
    Switch : process(SEL,temp_din,IN0,IN1)
    begin
        case SEL is
	       when '0'    => temp_din  <= IN0;
	       when '1'    => temp_din  <= IN1;
        end case;
    end process Switch;

    DOUT <= temp_din;
end Behavioral;
