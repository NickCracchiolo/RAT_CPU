----------------------------------------------------------------------------------
-- Company: Cal Poly
-- Engineer: Nick Cracchiolo
-- 
-- Create Date: 02/22/2016 05:53:23 PM
-- Design Name: Shadow Flag Register
-- Module Name: ShadFlagReg - Behavioral
-- Project Name: Experiment 9
-- Target Devices: Basys3
-- Tool Versions: Vivado 2014.4
-- Description: Holds, loads, and outputs a flag
-- 
-- Dependencies: None
-- 
-- Revision:
-- Revision 0.01 - File Created
-- Additional Comments:
-- 
----------------------------------------------------------------------------------
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity ShadFlagReg is
    Port ( IN_FLAG  : in STD_LOGIC;
           LD       : in STD_LOGIC;
           CLK      : in STD_LOGIC;
           OUT_FLAG : out STD_LOGIC);
end ShadFlagReg;

architecture Behavioral of ShadFlagReg is

--signal temp_sig : std_logic;

begin
    proc:process(IN_FLAG,LD,CLK)
    begin
        if( rising_edge(CLK) ) then
            if( LD = '1' ) then
                OUT_FLAG <= IN_FLAG;
            end if;
        end if;
    end process;
    --OUT_FLAG <= temp_sig;
    
end Behavioral;
