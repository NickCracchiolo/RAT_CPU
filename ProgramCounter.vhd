----------------------------------------------------------------------------------
-- Company: Cal Poly
-- Engineer: Nick Cracchiolo
-- 
-- Create Date: 01/06/2016 04:26:49 PM
-- Design Name: Program Counter
-- Module Name: ProgramCounter - Behavioral
-- Project Name: Experiment 3
-- Target Devices: Basys 3
-- Tool Versions: Vivado 2014.4
-- Description: Create a program counter with a MUX selecting the input to D
-- 
-- Dependencies: CLK_DIV_FS, STD_LOGIC_UNSIGNED.ALL
-- 
-- Revision:
-- Revision 0.01 - File Created
-- Additional Comments:
-- 
----------------------------------------------------------------------------------


library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx leaf cells in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity ProgramCounter is
    Port ( IN0      : in STD_LOGIC_VECTOR (9 downto 0);
           IN1      : in STD_LOGIC_VECTOR (9 downto 0);
           IN2      : in STD_LOGIC_VECTOR (9 downto 0);
           SEL      : in STD_LOGIC_VECTOR (1 downto 0);
           PC_OE    : in STD_LOGIC;
           PC_LD    : in STD_LOGIC;
           PC_INC   : in STD_LOGIC;
           RST      : in STD_LOGIC;
           CLK      : in STD_LOGIC;
           PC_COUNT : out STD_LOGIC_VECTOR (9 downto 0);
           PC_TRI   : out STD_LOGIC_VECTOR (9 downto 0));
end ProgramCounter;

architecture Behavioral of ProgramCounter is
	
--Create temporary signal for outputs to be assigned after process
signal d_in       : std_logic_vector (9 downto 0);
signal count_temp : std_logic_vector (9 downto 0);

begin
    MUX:process(IN0,IN1,IN2,SEL)
    begin
        if (SEL = "00") then
            d_in <= IN0;
        elsif (SEL = "01") then
            d_in <= IN1;
        elsif (SEL = "10") then
            d_in <= IN2;
        else
            d_in <= "0000000000";
        end if;
    end process MUX;
    
    Counter:process(CLK,RST,PC_INC,PC_LD,d_in)
	begin
		--Check for async reset
		if (RST = '1') then
			--Reset counter signal
			count_temp <= (others => '0');
		elsif (rising_edge(CLK)) then
		    if (PC_LD = '1') then
				count_temp <= d_in;
			else
                if (PC_INC = '1') then
					count_temp <= count_temp + 1;
				end if;
			end if;
		end if;
		
	end process Counter;
	
	PC_COUNT <= count_temp;
	PC_TRI <= count_temp when PC_OE='1' else (others=>'Z');


end Behavioral;

