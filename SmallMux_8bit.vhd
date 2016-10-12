----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 03/01/2016 05:14:14 PM
-- Design Name: 
-- Module Name: SmallMux_8bit - Behavioral
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

entity SmallMux_8bit is
    Port ( IN0 : in STD_LOGIC_VECTOR (7 downto 0);
           IN1 : in STD_LOGIC_VECTOR (7 downto 0);
           SEL : in STD_LOGIC;
           DOUT : out STD_LOGIC_VECTOR (7 downto 0));
end SmallMux_8bit;

architecture Behavioral of SmallMux_8bit is

signal temp_din : std_logic_vector(7 downto 0) := "00000000";

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
