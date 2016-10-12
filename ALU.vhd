----------------------------------------------------------------------------------
-- Company: Cal Poly
-- Engineer: Nick Cracchiolo
-- 
-- Create Date: 01/25/2016 04:10:58 PM
-- Design Name: ALU
-- Module Name: ALU - Behavioral
-- Project Name: Experiment 6
-- Target Devices: Basys3
-- Tool Versions: Vivado 2014.4
-- Description: Arithmetic Logic Unit, or the mod responsible for performing 
-- operations beyond what can be labeled as "arithmetic" or "logic"
-- Dependencies: None
-- Revision:
-- Revision 0.01 - File Created
-- Additional Comments:
----------------------------------------------------------------------------------
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;

entity ALU is
    Port ( A      : in STD_LOGIC_VECTOR (7 downto 0);
           B      : in STD_LOGIC_VECTOR (7 downto 0);
           C_IN   : in STD_LOGIC;
           SEL    : in STD_LOGIC_VECTOR (3 downto 0);
           SUM    : out STD_LOGIC_VECTOR (7 downto 0);
           C_FLAG : out STD_LOGIC;
           Z_FLAG : out STD_LOGIC);
end ALU;

architecture Behavioral of ALU is

signal sum_sig : std_logic_vector(8 downto 0) := "000000000";

begin

    switch_process : process(SEL,sum_sig,A,B,C_IN) 
    begin
        case SEL is
            when "0000" => sum_sig <= ('0' & A) + B; --ADD
            when "0001" => sum_sig <= ('0' & A) + B + C_IN; --ADDC
            when "0010" => sum_sig <= ('0' & A) - B; --SUB
            when "0011" => sum_sig <= ('0' & A) - B - C_IN; --SUBC
            when "0100" => sum_sig <= ('0' & A) - B; --CMP
            when "0101" => sum_sig <= ('0' & A) AND ('0' & B);--AND
            when "0110" => sum_sig <= ('0' & A) OR ('0' & B); --OR
            when "0111" => sum_sig <= ('0' & A) XOR ('0' & B); --EXOR
            when "1000" => sum_sig <= ('0' & A) AND ('0' & B); --TEST
            when "1001" => sum_sig <= (A & C_IN); --LSL
            when "1010" => sum_sig <= (A(0) & C_IN & A(7 downto 1)); --LSR
            when "1011" => sum_sig <= (A(7) & A(6 downto 0) & A(7)); --ROL
            when "1100" => sum_sig <= (A(0) & A(0) & A(7 downto 1)); --ROR
            when "1101" => sum_sig <= (A(0) & A(7) & A(7 downto 1)); --ASR
            when "1110" => sum_sig <= ('0' & B); --MOV
            when "1111" => sum_sig <= ('0' & B); --NOT USED
            when others => sum_sig <= ('0' & B); --IGNORE
        end case;
    end process switch_process;
    
    SUM    <= sum_sig(7 downto 0);
    C_FLAG <=  sum_sig(8);
    Z_FLAG <= '1' when sum_sig(7 downto 0) = x"00" else '0';
            
end Behavioral;
