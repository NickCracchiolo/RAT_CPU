----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 01/29/2016 04:24:15 PM
-- Design Name: 
-- Module Name: MUX - Behavioral
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

entity MUX is
    Port ( IN0  : in STD_LOGIC_VECTOR (9 downto 0);
           IN1  : in STD_LOGIC_VECTOR (9 downto 0);
           IN2  : in STD_LOGIC_VECTOR (9 downto 0);
           IN3  : in STD_LOGIC_VECTOR (9 downto 0);
           SEL  : in STD_LOGIC_VECTOR (1 downto 0);
           DOUT : out STD_LOGIC_VECTOR (9 downto 0));
end MUX;

architecture Behavioral of MUX is

signal temp_din : std_logic_vector (9 downto 0);

begin
    Switch : process(SEL,temp_din,IN0,IN1,IN2,IN3)
    begin
        case SEL is
	       when "00"   => temp_din <= IN0;
	       when "01"   => temp_din <= IN1;
	       when "10"   => temp_din <= IN2;
	       when "11"   => temp_din <= IN3;
	       when others => temp_din <= "0000000000";
        end case;
    end process Switch;

    DOUT <= temp_din;

end Behavioral;
