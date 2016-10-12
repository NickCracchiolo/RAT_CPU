----------------------------------------------------------------------------------
-- Company: Cal Poly
-- Engineer: Nick Cracchiolo
-- 
-- Create Date: 02/10/2016 04:06:25 PM
-- Design Name: RAT CPU
-- Module Name: RAT_CPU - Behavioral
-- Project Name: Experiment 9
-- Target Devices: Basys3
-- Tool Versions: Vivado 2014.4
-- Description: RAT CPU from EXP 7 with the SP and Scratch RAM
-- modules added
-- Dependencies: PC, MUX, prog_rom, ALU, MUX_8Bit, FlagReg, ControlUnit,
-- ScratchRAM, StackPointer, Increment, Decrement, Small Mux, ShadowFlagReg
-- Revision: 0.03 - Interrupts Added including Shadow flag modules and Control
-- Unit instructions for interrupts
-- Revision: 0.02 - Scratch RAM and SP added
-- Revision 0.01 - File Created
-- Additional Comments: Additional Muxes and Increment/Decrement
-- components added to make CPU work properly.
----------------------------------------------------------------------------------

library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;

entity RAT_CPU is
    Port ( IN_PORT  : in  STD_LOGIC_VECTOR (7 downto 0);
           RST      : in  STD_LOGIC;
           INT_IN   : in  STD_LOGIC;
           MAIN_CLK : in  STD_LOGIC;
           OUT_PORT : out STD_LOGIC_VECTOR (7 downto 0);
           PORT_ID  : out STD_LOGIC_VECTOR (7 downto 0);
           IO_OE    : out STD_LOGIC);
end RAT_CPU;

architecture Behavioral of RAT_CPU is
-----------------------------------------------------------
---------------------COMPONENTS----------------------------
-----------------------------------------------------------

--Program Counter Component
component ProgramCounter is 
	Port (IN0      : in  STD_LOGIC_VECTOR (9 downto 0);
	      IN1      : in  STD_LOGIC_VECTOR (9 downto 0);
	      IN2      : in  STD_LOGIC_VECTOR (9 downto 0);
	      SEL      : in STD_LOGIC_VECTOR(1 downto 0);
          PC_OE    : in  STD_LOGIC;
          PC_LD    : in  STD_LOGIC;
          PC_INC   : in  STD_LOGIC;
          RST      : in  STD_LOGIC;
          CLK      : in  STD_LOGIC;
          PC_COUNT : out STD_LOGIC_VECTOR (9 downto 0);
          PC_TRI   : out STD_LOGIC_VECTOR (9 downto 0));
end component;

--Prog_Rom Component
component prog_rom is
    Port (ADDRESS     : in  STD_LOGIC_VECTOR(9 downto 0);
          INSTRUCTION : out STD_LOGIC_VECTOR(17 downto 0);
          CLK         : in  STD_LOGIC);
end component;

--ALU Component
component ALU is 
    Port (A      : in  STD_LOGIC_VECTOR(7 downto 0);
          B      : in  STD_LOGIC_VECTOR(7 downto 0);
          C_IN   : in  STD_LOGIC;
          SEL    : in  STD_LOGIC_VECTOR(3 downto 0);
          SUM    : out STD_LOGIC_VECTOR(7 downto 0);
          C_FLAG : out STD_LOGIC;
          Z_FLAG : out STD_LOGIC);
end component;

--MUX component
component MUX is 
    Port (IN0  : in  STD_LOGIC_VECTOR(9 downto 0);
          IN1  : in  STD_LOGIC_VECTOR(9 downto 0);
          IN2  : in  STD_LOGIC_VECTOR(9 downto 0);
          IN3  : in  STD_LOGIC_VECTOR(9 downto 0);
          SEL  : in  STD_LOGIC_VECTOR(1 downto 0);
          DOUT : out STD_LOGIC_VECTOR(9 downto 0));
end component;

--8 BIT MUX component
component MUX_8Bit is 
    Port (IN0  : in  STD_LOGIC_VECTOR(7 downto 0);
          IN1  : in  STD_LOGIC_VECTOR(7 downto 0);
          IN2  : in  STD_LOGIC_VECTOR(7 downto 0);
          IN3  : in  STD_LOGIC_VECTOR(7 downto 0);
          SEL  : in  STD_LOGIC_VECTOR(1 downto 0);
          DOUT : out STD_LOGIC_VECTOR(7 downto 0));
end component;

--SMALL MUX component
component SmallMux is 
    Port (IN0  : in STD_LOGIC;
          IN1  : in STD_LOGIC;
          SEL  : in STD_LOGIC;
          DOUT : out STD_LOGIC);
end component;

--SMALL MUX 8 Bit component
component SmallMux_8bit is 
    Port (IN0  : in STD_LOGIC_VECTOR(7 downto 0);
          IN1  : in STD_LOGIC_VECTOR(7 downto 0);
          SEL  : in STD_LOGIC;
          DOUT : out STD_LOGIC_VECTOR(7 downto 0));
end component;

--Control Unit Component
component CONTROLUNIT
    Port (CLK           : in   STD_LOGIC;
          C             : in   STD_LOGIC;
          Z             : in   STD_LOGIC;
          INT           : in   STD_LOGIC;
          RST           : in   STD_LOGIC;
          OPCODE_HI_5   : in   STD_LOGIC_VECTOR (4 downto 0);
          OPCODE_LO_2   : in   STD_LOGIC_VECTOR (1 downto 0);
           
          PC_LD         : out  STD_LOGIC;
          PC_INC        : out  STD_LOGIC;
          PC_RESET      : out  STD_LOGIC;
          PC_OE         : out  STD_LOGIC;              
          PC_MUX_SEL    : out  STD_LOGIC_VECTOR (1 downto 0);
          SP_LD         : out  STD_LOGIC;
          SP_MUX_SEL    : out  STD_LOGIC_VECTOR (1 downto 0);
          SP_RESET      : out  STD_LOGIC;
          RF_WR         : out  STD_LOGIC;
          RF_WR_SEL     : out  STD_LOGIC_VECTOR (1 downto 0);
          RF_OE         : out  STD_LOGIC;
          REG_IMMED_SEL : out  STD_LOGIC;
          ALU_SEL       : out  STD_LOGIC_VECTOR (3 downto 0);
          SCR_WR        : out  STD_LOGIC;
          SCR_OE        : out  STD_LOGIC;
          SCR_ADDR_SEL  : out  STD_LOGIC_VECTOR (1 downto 0);
          SHADC_SEL     : out  STD_LOGIC;
          C_FLAG_LD     : out  STD_LOGIC;
          C_FLAG_SET    : out  STD_LOGIC;
          C_FLAG_CLR    : out  STD_LOGIC;
          SHAD_C_LD     : out  STD_LOGIC;
          SHADZ_SEL     : out  STD_LOGIC;
          Z_FLAG_LD     : out  STD_LOGIC;
          SHAD_Z_LD     : out  STD_LOGIC;
          I_FLAG_SET    : out  STD_LOGIC;
          I_FLAG_CLR    : out  STD_LOGIC;
          IO_OE         : out  STD_LOGIC);
end component;

--REG FILE Component
component RegisterFile 
    Port (D_IN   : in   STD_LOGIC_VECTOR (7 downto 0);
          DX_OUT : out  STD_LOGIC_VECTOR (7 downto 0);
          DY_OUT : out  STD_LOGIC_VECTOR (7 downto 0);
          ADRX   : in   STD_LOGIC_VECTOR (4 downto 0);
          ADRY   : in   STD_LOGIC_VECTOR (4 downto 0);
          DX_OE  : in   STD_LOGIC;
          WE     : in   STD_LOGIC;
          CLK    : in   STD_LOGIC);
end component;

--FLAG REG COMPONENT
component FlagReg
    Port (IN_FLAG  : in  STD_LOGIC;
          LD       : in  STD_LOGIC;
          SET      : in  STD_LOGIC;
          CLR      : in  STD_LOGIC;
          CLK      : in  STD_LOGIC;
          OUT_FLAG : out STD_LOGIC);
end component;

--SCRATCH RAM COMPONENT
component ScratchRAM
    Port (IN0      : in STD_LOGIC_VECTOR (7 downto 0);
          IN1      : in STD_LOGIC_VECTOR (7 downto 0);
          IN2      : in STD_LOGIC_VECTOR (7 downto 0);
          IN3      : in STD_LOGIC_VECTOR (7 downto 0);
          SEL      : in STD_LOGIC_VECTOR (1 downto 0);
          SCR_OE   : in STD_LOGIC;
          SCR_WE   : in STD_LOGIC;
          CLK      : in STD_LOGIC;
          SCR_DATA : inout STD_LOGIC_VECTOR(9 downto 0));
end component;

--STACK POINTER COMPONENT
component StackPointer
    Port (IN0      : in STD_LOGIC_VECTOR(7 downto 0);
          IN1      : in STD_LOGIC_VECTOR(7 downto 0);
          IN2      : in STD_LOGIC_VECTOR(7 downto 0);
          IN3      : in STD_LOGIC_VECTOR(7 downto 0);
          SEL      : in STD_LOGIC_VECTOR(1 downto 0);
          LD       : in STD_LOGIC;
          RST      : in STD_LOGIC;
          CLK      : in STD_LOGIC;
          OUT_PORT : out STD_LOGIC_VECTOR(7 downto 0);
          DEC_OUT  : out STD_LOGIC_VECTOR(7 downto 0);
          INC_OUT  : out STD_LOGIC_VECTOR(7 downto 0));
end component;

component db_1shot_FSM
    Port ( A    : in  STD_LOGIC;
           CLK  : in  STD_LOGIC;
           A_DB : out STD_LOGIC);
end component db_1shot_FSM;
       
-----------------------------------------------------------
------------------------SIGNALS----------------------------
-----------------------------------------------------------

--Program Counter signals
signal pc_ld_sig    : std_logic := '0'; 
signal pc_inc_sig   : std_logic := '0'; 
signal pc_oe_sig    : std_logic := '0'; 
signal pc_rst_sig   : std_logic := '0'; 
signal pc_count_sig : std_logic_vector(9 downto 0) := (others => '0');  
signal pcmux_sel_sig : std_logic_vector(1 downto 0) := "00"; 

--Prog Rom Signals 
signal instruction_sig : std_logic_vector(17 downto 0) := (others => '0'); 

--Reg File Signals
signal rf_mux_sel_sig : std_logic_vector(1 downto 0) := "00";
signal rf_dxout_sig   : std_logic_vector(7 downto 0) := "00000000";
signal rf_dyout_sig   : std_logic_vector(7 downto 0) := "00000000";
signal rf_oe_sig      : std_logic := '0';
signal rf_wr_sig      : std_logic := '0';

--REG FILE MUX signals 
signal rfmux_out_sig : std_logic_vector(7 downto 0) := (others => '0');
signal rf_wr_sel_sig : std_logic_vector(1 downto 0) := "00"; 

--REG TO ALU MUX Signals
signal alu_mux_out_sig   : std_logic_vector(7 downto 0) := (others => '0');
signal reg_immed_sel_sig : std_logic := '0'; 

--C FlagReg signals
signal c_ld_sig     : std_logic := '0';
signal c_set_sig    : std_logic := '0';
signal c_clr_sig    : std_logic := '0';
signal cflag_sig    : std_logic := '0';
signal c_sel_sig    : std_logic := '0';

--C Shad Flag signals
signal shad_cld_sig  : std_logic := '0';
signal shadc_out_sig : std_logic := '0';

--C Flag MUX signals
signal c_mux_out_sig : std_logic := '0';

--C FlagReg signals
signal z_ld_sig     : std_logic := '0';
signal zflag_sig    : std_logic := '0';
signal z_sel_sig    : std_logic := '0';

--Z Shad Flag signals
signal shad_zld_sig  : std_logic := '0';
signal shadz_out_sig : std_logic := '0';

--Z Flag MUX signals
signal z_mux_out_sig : std_logic := '0';

--ALU signals
signal alu_sum_sig  : std_logic_vector(7 downto 0) := (others => '0');
signal alu_sel_sig  : std_logic_vector(3 downto 0) := "0000";
signal alu_cout_sig : std_logic := '0';
signal alu_zout_sig : std_logic := '0';

--ScratchRAM signals
signal scr_addr_sel_sig : std_logic_vector(1 downto 0) := "00";
signal scr_wr_sig       : std_logic := '0';
signal scr_oe_sig       : std_logic := '0';
signal scr_out_sig      : std_logic_vector(7 downto 0) := (others => '0');

--Stack Pointer signals
signal sp_mux_sel_sig : std_logic_vector(1 downto 0) := "00";
signal sp_mux_out_sig : std_logic_vector(7 downto 0) := (others => '0');
signal sp_rst_sig     : std_logic := '0';
signal sp_ld_sig      : std_logic := '0';
signal sp_out_sig     : std_logic_vector(7 downto 0) := (others => '0');
signal sp_inc_sig     : std_logic_vector(7 downto 0) := (others => '0');
signal sp_dec_sig     : std_logic_vector(7 downto 0) := (others => '0');

--Increment Signals
signal inc_out_sig : std_logic_vector(7 downto 0) := (others => '0');

--Decremet Signals
signal dec_out_sig : std_logic_vector(7 downto 0) := (others => '0');

--IFLAG Signals
signal andgate_out_sig : std_logic := '0';
signal i_set_sig       : std_logic := '0';
signal i_clr_sig       : std_logic := '0';
signal i_out_sig       : std_logic := '0';

--Debounce Signal
signal s_int_db : std_logic;

--Other signals
signal multi_bus : std_logic_vector(9 downto 0) := (others => '0');

begin

-----------------------------------------------------------
-------------------PORT MAPPING----------------------------
-----------------------------------------------------------
    andgate_out_sig <= (s_int_db AND i_out_sig);
    
    debounce: db_1shot_FSM
    port map ( A       => INT_IN,
               CLK     => MAIN_CLK,
               A_DB    => s_int_db);
               
    --PROGRAM COUNTER PORT MAP
    pc_comp: ProgramCounter
    port map (IN0      => instruction_sig(12 downto 3),
              IN1      => multi_bus,
              IN2      => "1111111111",
              SEL      => pcmux_sel_sig,
              PC_OE    => pc_oe_sig,
              PC_LD    => pc_ld_sig,
              PC_INC   => pc_inc_sig,
              RST      => pc_rst_sig,
              CLK      => MAIN_CLK,
              PC_COUNT => pc_count_sig,
              PC_TRI   => multi_bus);
              
    --PROG ROM PORT MAP
    progrom_comp: prog_rom
    port map (ADDRESS     => pc_count_sig,
              INSTRUCTION => instruction_sig,
              CLK         => MAIN_CLK);
    
    --ALU PORT MAP
    alu_comp: ALU
    port map (A      => multi_bus(7 downto 0),
              B      => alu_mux_out_sig,
              C_IN   => cflag_sig,
              SEL    => alu_sel_sig,
              SUM    => alu_sum_sig,
              C_FLAG => alu_cout_sig,
              Z_FLAG => alu_zout_sig);
              
     --REG to ALU MUX
     alu_mux: SmallMux_8bit
     port map (IN0  => rf_dyout_sig,
               IN1  => instruction_sig(7 downto 0),
               SEL  => reg_immed_sel_sig,
               DOUT => alu_mux_out_sig);
    
    --C FLAG MUX
    c_flag_mux: SmallMux
    port map (IN0  => alu_cout_sig,
              IN1  => shadc_out_sig,
              SEL  => c_sel_sig,
              DOUT => c_mux_out_sig);
        
    --C FLAG REG
    c_flag_reg: FlagReg
    port map (IN_FLAG  => c_mux_out_sig,
              LD       => c_ld_sig,
              SET      => c_set_sig,
              CLR      => c_clr_sig,
              CLK      => MAIN_CLK,
              OUT_FLAG => cflag_sig);

    --ShadC FLAG REG
    shadc_reg: FlagReg
    port map (IN_FLAG  => cflag_sig,
              LD       => shad_cld_sig,
              SET      => '0',
              CLR      => '0',
              CLK      => MAIN_CLK,
              OUT_FLAG => shadc_out_sig); 
              
    --Z FLAG MUX
    z_flag_mux: SmallMux
    port map (IN0  => alu_zout_sig,
              IN1  => shadz_out_sig,
              SEL  => z_sel_sig,
              DOUT => z_mux_out_sig);
              
    --Z FLAG REG
    z_flag_reg: FlagReg
    port map (IN_FLAG  => z_mux_out_sig,
              LD       => z_ld_sig,
              SET      => '0',
              CLR      => '0',
              CLK      => MAIN_CLK,
              OUT_FLAG => zflag_sig);
              
    --ShadZ FLAG REG
    shadz_reg: FlagReg
    port map (IN_FLAG  => zflag_sig,
              LD       => shad_zld_sig,
              SET      => '0',
              CLR      => '0',
              CLK      => MAIN_CLK,
              OUT_FLAG => shadz_out_sig);   
                     
    --I FLAG REG
    i_flag_reg: FlagReg
    port map (IN_FLAG  => '0',
              LD       => '0',
              SET      => i_set_sig,
              CLR      => i_clr_sig,
              CLK      => MAIN_CLK,
              OUT_FLAG => i_out_sig);
    
    --MUX for the Reg_file
    rf_mux_comp: MUX_8Bit
    port map (IN0  => alu_sum_sig,
              IN1  => multi_bus(7 downto 0),
              IN2  => "00000000",
              IN3  => IN_PORT,
              SEL  => rf_wr_sel_sig,
              DOUT => rfmux_out_sig);
                        
    --REG FILE PORT MAP
    regfile_comp: RegisterFile 
    port map (D_IN   => rfmux_out_sig,   
              DX_OUT => multi_bus(7 downto 0),   
              DY_OUT => rf_dyout_sig,   
              ADRX   => instruction_sig(12 downto 8),   
              ADRY   => instruction_sig(7 downto 3),   
              DX_OE  => rf_oe_sig,   
              WE     => rf_wr_sig,   
              CLK    => MAIN_CLK); 
    
    --Scratch RAM
    scr_comp: ScratchRAM
    port map (IN0      => rf_dyout_sig,
              IN1      => instruction_sig(7 downto 0),
              IN2      => sp_out_sig,
              IN3      => dec_out_sig,
              SEL      => scr_addr_sel_sig,
              SCR_OE   => scr_oe_sig,
              SCR_WE   => scr_wr_sig,
              CLK      => MAIN_CLK,
              SCR_DATA => multi_bus);
    
    --Stack Pointer
    sp_comp: StackPointer
    port map (IN0      => multi_bus(7 downto 0),
              IN1      => "00000000",
              IN2      => dec_out_sig,
              IN3      => inc_out_sig,
              SEL      => sp_mux_sel_sig,
              LD       => sp_ld_sig,
              RST      => sp_rst_sig,
              CLK      => MAIN_CLK,
              OUT_PORT => sp_out_sig,
              DEC_OUT  => dec_out_sig,
              INC_OUT  => inc_out_sig);
    
        -- CONTROL UNIT PORT MAP
    my_comp: CONTROLUNIT 
    port map (CLK           => MAIN_CLK, 
              C             => cflag_sig, 
              Z             => zflag_sig, 
              INT           => andgate_out_sig,
              RST           => RST, 
              OPCODE_HI_5   => instruction_sig(17 downto 13),
              OPCODE_LO_2   => instruction_sig(1 downto 0),
              
              PC_LD         => pc_ld_sig, 
              PC_INC        => pc_inc_sig, 
              PC_RESET      => pc_rst_sig, 
              PC_OE         => pc_oe_sig, 
              PC_MUX_SEL    => pcmux_sel_sig, 
              SP_LD         => sp_ld_sig, 
              SP_MUX_SEL    => sp_mux_sel_sig,
              SP_RESET      => sp_rst_sig,
              RF_WR         => rf_wr_sig, 
              RF_WR_SEL     => rf_wr_sel_sig, 
              RF_OE         => rf_oe_sig, 
              REG_IMMED_SEL => reg_immed_sel_sig,
              ALU_SEL       => alu_sel_sig, 
              SCR_WR        => scr_wr_sig,
              SCR_OE        => scr_oe_sig,
              SCR_ADDR_SEL  => scr_addr_sel_sig,
              SHADC_SEL     => c_sel_sig,
              C_FLAG_LD     => c_ld_sig, 
              C_FLAG_SET    => c_set_sig, 
              C_FLAG_CLR    => c_clr_sig, 
              SHAD_C_LD     => shad_cld_sig,
              SHADZ_SEL     => z_sel_sig,
              Z_FLAG_LD     => z_ld_sig, 
              SHAD_Z_LD     => shad_zld_sig,
              I_FLAG_SET    => i_set_sig,
              I_FLAG_CLR    => i_clr_sig,
              IO_OE         => IO_OE);
              
    OUT_PORT <= multi_bus(7 downto 0);
    PORT_ID <= instruction_sig(7 downto 0);
    
end Behavioral;
