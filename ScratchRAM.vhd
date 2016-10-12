----------------------------------------------------------------------------------
-- Company: Cal Poly
-- Engineer: Nick Cracchiolo
-- 
-- Create Date: 01/20/2016 06:10:33 PM
-- Design Name: ScratchRAM
-- Module Name: ScratchRAM - Behavioral
-- Project Name: Experiment 5
-- Target Devices: Basys3
-- Tool Versions: Vivado 2014.4
-- Description: Provides temporary storage accessible by the RAT instruction
-- manual. Also used as a storage device for the Stack. 256x10 bits
-- Dependencies: None
-- Revision:
-- Revision 0.01 - File Created
----------------------------------------------------------------------------------

library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;

entity ScratchRAM is
    Port (IN0      : in STD_LOGIC_VECTOR (7 downto 0);
          IN1      : in STD_LOGIC_VECTOR (7 downto 0);
          IN2      : in STD_LOGIC_VECTOR (7 downto 0);
          IN3      : in STD_LOGIC_VECTOR (7 downto 0);
          SEL      : in STD_LOGIC_VECTOR (1 downto 0);
          SCR_OE   : in STD_LOGIC;
          SCR_WE   : in STD_LOGIC;
          CLK      : in STD_LOGIC;
          SCR_DATA : inout STD_LOGIC_VECTOR (9 downto 0));
end ScratchRAM;

architecture Behavioral of ScratchRAM is

    TYPE memory is array (0 to 255) of std_logic_vector(9 downto 0);
    SIGNAL REG: memory := (others=>(others=>'0'));
    signal scr_addr : std_logic_vector(7 downto 0);
    
begin
    MUX: process(IN0,IN1,IN2,IN3,SEL,scr_addr)
    begin
        if (SEL = "00") then
            scr_addr <= IN0;
        elsif (SEL = "01") then
            scr_addr <= IN1;
        elsif (SEL = "10") then
            scr_addr <= IN2;
        elsif (SEL = "11") then
            scr_addr <= IN3;
        else
            scr_addr <= "00000000";
        end if;
    end process MUX; 
    
    RAM_proc: process(clk,SCR_WE,scr_addr,SCR_DATA)
    begin
        if (rising_edge(clk)) then
            if (SCR_WE = '1') then
                REG(conv_integer(scr_addr)) <= SCR_DATA;
            end if;
        end if;
    end process RAM_proc;
    
    SCR_DATA <= REG(conv_integer(scr_addr)) when SCR_OE='1' else (others => 'Z');

end Behavioral;
