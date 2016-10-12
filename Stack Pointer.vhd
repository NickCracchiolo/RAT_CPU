----------------------------------------------------------------------------------
-- Company: Cal Poly
-- Engineer: Nick Cracchiolo
-- 
-- Create Date: 02/08/2016 04:08:19 PM
-- Design Name: Experiment 8
-- Module Name: StackPointer - Behavioral
-- Project Name: Stack Pointer
-- Target Devices: Basys3
-- Tool Versions: Vivado 2014.4
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

entity StackPointer is
    Port ( IN0      : in STD_LOGIC_VECTOR (7 downto 0);
           IN1      : in STD_LOGIC_VECTOR (7 downto 0);
           IN2      : in STD_LOGIC_VECTOR (7 downto 0);
           IN3      : in STD_LOGIC_VECTOR (7 downto 0);
           SEL      : in STD_LOGIC_VECTOR (1 downto 0);
           LD       : in STD_LOGIC;
           RST      : in STD_LOGIC;
           CLK      : in STD_LOGIC;
           OUT_PORT : out STD_LOGIC_VECTOR (7 downto 0);
           DEC_OUT  : out STD_LOGIC_VECTOR (7 downto 0);
           INC_OUT  : out STD_LOGIC_VECTOR (7 downto 0));
end StackPointer;

architecture Behavioral of StackPointer is

--Signal to hold output value
signal mux_out : std_logic_vector(7 downto 0);
signal out_sig : std_logic_vector(7 downto 0);

begin

    MUX:process(IN0,IN1,IN2,IN3,SEL,mux_out)
    begin
        if (SEL = "00") then
            mux_out <= IN0;
        elsif (SEL = "01") then
            mux_out <= IN1;
        elsif (SEL = "10") then
            mux_out <= IN2;
        elsif (SEL <= "11") then
            mux_out <= IN3;
        else
            mux_out <= "00000000";
        end if;
    end process MUX;
    
    --Stack Pointer process
    stack_proc:process(out_sig, CLK, mux_out, LD, RST)
    begin
        --Async Reset check
        if (RST = '1') then
            out_sig <= "00000000";
        else --Rising edge of clock sync check
            if (rising_edge(CLK)) then
                --Check if LD is high, if so place the IN_PORT
                --Value into the temp out signal
                if (LD = '1') then
                    out_sig <= mux_out;
                end if;
            end if;
        end if;
    end process;
    
    --Assign the OUT_PORT the temp signal outside process.
    OUT_PORT <= out_sig;
    DEC_OUT  <= out_sig - '1';
    INC_OUT  <= out_sig + '1';

end Behavioral;
