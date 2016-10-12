----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 02/01/2016 03:53:17 PM
-- Design Name: 
-- Module Name: FlagReg - Behavioral
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

entity FlagReg is
    Port ( IN_FLAG  : in  STD_LOGIC;
           LD       : in  STD_LOGIC;
           SET      : in  STD_LOGIC;
           CLR      : in  STD_LOGIC;
           CLK      : in  STD_LOGIC;
           OUT_FLAG : out STD_LOGIC);
end FlagReg;

architecture Behavioral of FlagReg is

begin
    process(CLK)
    begin
        if( rising_edge(CLK) ) then
            if( LD = '1' ) then
                OUT_FLAG <= IN_FLAG;
            elsif( SET = '1' ) then
                OUT_FLAG <= '1';
            elsif( CLR = '1' ) then
                OUT_FLAG <= '0';
         end if;
      end if;
    end process;    
end Behavioral;
