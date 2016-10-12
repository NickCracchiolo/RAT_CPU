----------------------------------------------------------------------------------
-- Company: Cal Poly
-- Engineer: Nick Cracchiolo
-- 
-- Create Date: 02/05/2016 06:35:20 PM
-- Design Name: RAT_WRAPPER
-- Module Name: RAT_WRAPPER - Behavioral
-- Project Name: Experiment 9
-- Target Devices: Basys3
-- Tool Versions: Vivado 2014.4
-- Description: Wrapper for the RAT_CPU to connect to the Basys3 board
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

entity RAT_CPU_WRAPPER is
    Port ( LEDS     : out STD_LOGIC_VECTOR (7 downto 0);
           SWITCHES : in STD_LOGIC_VECTOR (7 downto 0);
           INT      : in STD_LOGIC;
           RST      : in STD_LOGIC;
           CLK      : in STD_LOGIC);
end RAT_CPU_WRAPPER;

architecture Behavioral of RAT_CPU_WRAPPER is
    -- INPUT PORT IDS -------------------------------------------------------------
    -- Right now, the only possible inputs are the switches
    -- In future labs you can add more port IDs, and you'll have
    -- to add constants here for the mux below
    CONSTANT SWITCHES_ID : STD_LOGIC_VECTOR (7 downto 0) := X"20";
     -------------------------------------------------------------------------------
   
    -------------------------------------------------------------------------------
    -- OUTPUT PORT IDS ------------------------------------------------------------
    -- In future labs you can add more port IDs
    CONSTANT LEDS_ID    : STD_LOGIC_VECTOR (7 downto 0) := X"40";
    -------------------------------------------------------------------------------

    -- Declare RAT_CPU ------------------------------------------------------------
    component RAT_CPU 
        Port ( IN_PORT  : in  STD_LOGIC_VECTOR (7 downto 0);
               OUT_PORT : out STD_LOGIC_VECTOR (7 downto 0);
               PORT_ID  : out STD_LOGIC_VECTOR (7 downto 0);
               IO_OE    : out STD_LOGIC;
               RST      : in  STD_LOGIC;
               INT_IN   : in  STD_LOGIC;
               MAIN_CLK : in  STD_LOGIC);
    end component RAT_CPU;
    
    --component clk_div_fs
      --  Port ( CLK  : in STD_LOGIC;
        --       FCLK : out STD_LOGIC;
          --     SCLK : out STD_LOGIC);
    --end component; 
    -------------------------------------------------------------------------------

    -- Signals for connecting RAT_CPU to RAT_wrapper -------------------------------
    signal s_input_port  : std_logic_vector (7 downto 0);
    signal s_output_port : std_logic_vector (7 downto 0);
    signal s_port_id     : std_logic_vector (7 downto 0);
    signal s_load        : std_logic;
    signal s_interrupt   : std_logic := '0'; -- not yet used
   
    --Signals for Clock processes
    signal clk_sig       : std_logic := '0';
    
    --Signals for connecting Wrapper to debounce to CPU
    signal s_a_db        : std_logic;
    
    -- Register definitions for output devices ------------------------------------
    signal r_LEDS        : std_logic_vector (7 downto 0); 
    -------------------------------------------------------------------------------

begin
    s_interrupt <= INT;
    
    -- Instantiate RAT_CPU --------------------------------------------------------
    CPU: RAT_CPU
    port map(  IN_PORT  => s_input_port,
               OUT_PORT => s_output_port,
               PORT_ID  => s_port_id,
               RST      => RST,  
               IO_OE    => s_load,
               INT_IN   => s_interrupt,
               MAIN_CLK => clk_sig);         
    -------------------------------------------------------------------------------
    
    -- Instantiate Clock Divder
    --clk_div: clk_div_fs
    --port map( CLK       => CLK,
    --          FCLK      => open,
    --          SCLK      => clk_sig);
    CLK_div: process(CLK)
    begin
        if(rising_edge(CLK)) then
            clk_sig <= not clk_sig;
        end if;
    end process CLK_div;
    ------------------------------------------------------------------------------- 
    -- MUX for selecting what input to read ---------------------------------------
    -------------------------------------------------------------------------------
    inputs: process(s_port_id, SWITCHES)
    begin
        if (s_port_id = SWITCHES_ID) then
            s_input_port <= SWITCHES;
        else
            s_input_port <= x"00";
        end if;
    end process inputs;
   -------------------------------------------------------------------------------


    -------------------------------------------------------------------------------
    -- MUX for updating output registers ------------------------------------------
    -- Register updates depend on rising clock edge and asserted load signal
    -------------------------------------------------------------------------------
    outputs: process(clk_sig) 
    begin   
        if (rising_edge(clk_sig)) then
            if (s_load = '1') then 
                -- the register definition for the LEDS
                if (s_port_id = LEDS_ID) then
                    r_LEDS <= s_output_port;
                end if;
            end if; 
        end if;
    end process outputs;      
    -------------------------------------------------------------------------------

    -- Register Interface Assignments ---------------------------------------------
    LEDS <= r_LEDS; 

end Behavioral;
