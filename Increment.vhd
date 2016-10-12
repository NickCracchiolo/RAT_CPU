----------------------------------------------------------------------------------
-- Company: Cal Poly    
-- Engineer: Nick Cracchiolo
-- 
-- Create Date: 02/16/2016 04:45:19 PM
-- Design Name: Increment
-- Module Name: Increment - Behavioral
-- Project Name: Experiment 8
-- Target Devices: Basys3
-- Tool Versions: Vivado 2014.4
-- Description: Module to incremement signal by one
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
use IEEE.STD_LOGIC_UNSIGNED.ALL;

entity Increment is
    Port ( IN_PORT : in STD_LOGIC_VECTOR (7 downto 0);
           OUT_PORT : out STD_LOGIC_VECTOR (7 downto 0));
end Increment;

architecture Behavioral of Increment is

signal temp_sig: std_logic_vector(7 downto 0);

begin
    inc_proc:process(IN_PORT,temp_sig)
    begin
        temp_sig <= (IN_PORT +'1');
    end process;

OUT_PORT <= temp_sig;

end Behavioral;
