----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 02/16/2016 04:49:46 PM
-- Design Name: 
-- Module Name: Decrement - Behavioral
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
use IEEE.STD_LOGIC_UNSIGNED.ALL;

entity Decrement is
    Port ( IN_PORT : in STD_LOGIC_VECTOR (7 downto 0);
           OUT_PORT : out STD_LOGIC_VECTOR (7 downto 0));
end Decrement;

architecture Behavioral of Decrement is

signal temp_sig: std_logic_vector(7 downto 0);

begin
    inc_proc:process(IN_PORT,temp_sig)
    begin
        temp_sig <= (IN_PORT -'1');
    end process;

OUT_PORT <= temp_sig;

end Behavioral;
