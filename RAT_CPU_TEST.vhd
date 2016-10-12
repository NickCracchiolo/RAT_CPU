----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 03/02/2016 04:13:40 PM
-- Design Name: 
-- Module Name: RAT_CPU_TEST - Behavioral
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

entity RAT_CPU_TEST is
end RAT_CPU_TEST;

architecture Behavioral of RAT_CPU_TEST is
--COMPONENT
COMPONENT RAT_CPU is
        Port (IN_PORT  : in STD_LOGIC_VECTOR (7 downto 0);
              RST      : in STD_LOGIC;
              INT_IN   : in STD_LOGIC;
              MAIN_CLK : in STD_LOGIC;
              OUT_PORT : out STD_LOGIC_VECTOR (7 downto 0);
              PORT_ID  : out STD_LOGIC_VECTOR (7 downto 0);
              IO_OE    : out STD_LOGIC);
end COMPONENT;

--INPUT SIGNALS
signal in_port_sig  : std_logic_vector(7 downto 0) := "00000000";
signal rst_sig      : std_logic := '0';
signal int_in_sig   : std_logic := '0';
signal clk_sig      : std_logic := '0';

--OUTPUT SIGNALS
signal out_port_sig : std_logic_vector(7 downto 0) := "00000000";
signal port_id_sig  : std_logic_vector(7 downto 0) := "00000000";
signal io_oe_sig    : std_logic := '0';

--CONSTANTS
--Time Constant
constant clk_period : time := 10ns;
 
begin
    --PORT MAP RAT_CPU
    uut: RAT_CPU
    port map (IN_PORT  => in_port_sig,
              RST      => rst_sig,
              INT_IN   => int_in_sig,
              MAIN_CLK => clk_sig,
              OUT_PORT => out_port_sig,
              PORT_ID  => port_id_sig,
              IO_OE    => io_oe_sig);
              
    --CLOCK PROCESS
    clk_proc: process
        begin
            clk_sig <= '0';
            wait for clk_period/2;
            clk_sig <= '1';
            wait for clk_period/2;
     end process;
     
     --Run inital Reset process
     reset_proc: process
        begin
            in_port_sig <= "10101010"; 
            rst_sig <= '1';
            int_in_sig <= '0';
            wait for 10ns;
            rst_sig <= '0';
            wait for 425ns;
            int_in_sig <= '0';
            wait for 5ns;
            int_in_sig <= '0';
            wait for 145ns;
            int_in_sig <= '0';
            wait for 5ns;
            int_in_sig <= '0';
            wait;
      end process;
            

end Behavioral;
