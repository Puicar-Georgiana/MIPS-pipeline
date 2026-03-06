library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;

entity test_env2 is
    Port( sw: in STD_LOGIC_VECTOR(7 downto 0);
          btn: in STD_LOGIC_VECTOR(4 downto 0);
          clk: in STD_LOGIC;
          cat: out STD_LOGIC_VECTOR(6 downto 0);
          an: out STD_LOGIC_VECTOR(7 downto 0);
          led: out STD_LOGIC_VECTOR (15 downto 0));
end test_env2;

architecture Behavioral of test_env2 is

component MPG is
    Port ( enable: out STD_LOGIC;
           btn: in STD_LOGIC;
           clk: in STD_LOGIC);
end component;

component IFetch is
    Port (Jump : in STD_LOGIC;
          JumpAddress : in STD_LOGIC_VECTOR(31 downto 0);
          PCSrc : in STD_LOGIC;
          BranchAddress : in STD_LOGIC_VECTOR(31 downto 0);
          En : in STD_LOGIC;
          RST : in STD_LOGIC;
          clk : in STD_LOGIC;
          PC : out STD_LOGIC_VECTOR(31 downto 0);
          Instruction : out STD_LOGIC_VECTOR(31 downto 0));
end component;

component UC is
    Port (Instr : in STD_LOGIC_VECTOR(5 downto 0);
          RegDst : out STD_LOGIC;
          ExtOp : out STD_LOGIC;
          ALUSrc : out STD_LOGIC;
          Branch : out STD_LOGIC;
          Jump : out STD_LOGIC;
          ALUOp : out STD_LOGIC_VECTOR(1 downto 0);
          MemWrite : out STD_LOGIC;
          MemtoReg : out STD_LOGIC;
          RegWrite : out STD_LOGIC);
end component;

component ID is
    Port(RD1 : out std_logic_vector(31 downto 0);
        RD2 : out std_logic_vector(31 downto 0);
        Ext_Imm : out std_logic_vector(31 downto 0);
        func : out std_logic_vector(5 downto 0);
        sa : out std_logic_vector(4 downto 0);
        rt : out std_logic_vector(4 downto 0);
        rd : out std_logic_vector(4 downto 0);
        WD : in std_logic_vector(31 downto 0);
        Instr : in std_logic_vector(25 downto 0);
        WA: in std_logic_vector(4 downto 0);
        clk:in std_logic;
        en: in std_logic;
        RegWrite: in std_logic;
        ExtOp: in std_logic);
end component;

component EX is
    Port ( RD1 : in STD_LOGIC_VECTOR (31 downto 0);
           RD2 : in STD_LOGIC_VECTOR (31 downto 0);
           Ext_imm : in STD_LOGIC_VECTOR (31 downto 0);
           ALUSrc : in STD_LOGIC;
           sa : in STD_LOGIC_VECTOR (4 downto 0);
           func : in STD_LOGIC_VECTOR (5 downto 0);
           ALUOp : in STD_LOGIC_VECTOR (1 downto 0);
           PC : in STD_LOGIC_VECTOR (31 downto 0);
           rt : in STD_LOGIC_VECTOR (4 downto 0);
           rd : in STD_LOGIC_VECTOR (4 downto 0);
           RegDst : in STD_LOGIC;
           ALURes : out STD_LOGIC_VECTOR (31 downto 0);
           BranchAddress : out STD_LOGIC_VECTOR (31 downto 0);
           Zero : out STD_LOGIC;
           rWA : out STD_LOGIC_VECTOR(4 downto 0));
end component;

component MEM is
    Port ( MemWrite : in STD_LOGIC;
           ALURes : in STD_LOGIC_VECTOR (31 downto 0);
           RD2 : in STD_LOGIC_VECTOR (31 downto 0);
           clk : in STD_LOGIC;
           en : in STD_LOGIC;
           MemData : out STD_LOGIC_VECTOR (31 downto 0);
           ALUResOut : out STD_LOGIC_VECTOR (31 downto 0));
end component;

component SSD is
    Port ( clk : in STD_LOGIC;
           digits : in STD_LOGIC_VECTOR(31 downto 0);
           an : out STD_LOGIC_VECTOR(7 downto 0);
           cat : out STD_LOGIC_VECTOR(6 downto 0));
end component;

signal en : STD_LOGIC;

signal Jump : STD_LOGIC;
signal JumpAddress : STD_LOGIC_VECTOR(31 downto 0);
signal PCSrc : STD_LOGIC;
signal BranchAddress : STD_LOGIC_VECTOR(31 downto 0);
signal PC : STD_LOGIC_VECTOR(31 downto 0);
signal Instruction : STD_LOGIC_VECTOR(31 downto 0);

signal Instruction_IF_ID : STD_LOGIC_VECTOR(31 downto 0);
signal PC_IF_ID : STD_LOGIC_VECTOR(31 downto 0);

signal RD1 : std_logic_vector(31 downto 0);
signal RD2 : std_logic_vector(31 downto 0);
signal Ext_Imm : std_logic_vector(31 downto 0);
signal func : std_logic_vector(5 downto 0);
signal sa : std_logic_vector(4 downto 0);
signal rt : std_logic_vector(4 downto 0);
signal rd : std_logic_vector(4 downto 0);
signal WD : std_logic_vector(31 downto 0);
signal Instr : std_logic_vector(25 downto 0);
signal WA : std_logic_vector(4 downto 0);

signal RegDst : STD_LOGIC;
signal ExtOp : STD_LOGIC;
signal ALUSrc : STD_LOGIC;
signal Branch : STD_LOGIC;
signal ALUOp : STD_LOGIC_VECTOR(1 downto 0);
signal MemWrite : STD_LOGIC;
signal MemtoReg : STD_LOGIC;
signal RegWrite : STD_LOGIC;

signal RegDst_ID_EX : STD_LOGIC;
signal ALUSrc_ID_EX : STD_LOGIC;
signal Branch_ID_EX : STD_LOGIC;
signal ALUOp_ID_EX : STD_LOGIC_VECTOR(1 downto 0);
signal MemWrite_ID_EX : STD_LOGIC;
signal MemtoReg_ID_EX : STD_LOGIC;
signal RegWrite_ID_EX : STD_LOGIC;
signal RD1_ID_EX : STD_LOGIC_VECTOR(31 downto 0);
signal RD2_ID_EX : STD_LOGIC_VECTOR(31 downto 0);
signal Ext_Imm_ID_EX : STD_LOGIC_VECTOR(31 downto 0);
signal func_ID_EX : STD_LOGIC_VECTOR(5 downto 0);
signal sa_ID_EX : STD_LOGIC_VECTOR(4 downto 0);
signal rd_ID_EX : STD_LOGIC_VECTOR(4 downto 0);
signal rt_ID_EX : STD_LOGIC_VECTOR(4 downto 0);
signal PC_ID_EX : STD_LOGIC_VECTOR(31 downto 0);

signal ALURes : STD_LOGIC_VECTOR(31 downto 0);
signal rWA : STD_LOGIC_VECTOR(4 downto 0);
signal Zero : STD_LOGIC := '0';

signal Branch_EX_MEM : STD_LOGIC;
signal MemWrite_EX_MEM : STD_LOGIC;
signal MemtoReg_EX_MEM : STD_LOGIC;
signal RegWrite_EX_MEM : STD_LOGIC;
signal Zero_EX_MEM : STD_LOGIC;
signal BranchAddress_EX_MEM : STD_LOGIC_VECTOR(31 downto 0);
signal ALURes_EX_MEM : STD_LOGIC_VECTOR(31 downto 0);
signal WA_EX_MEM : STD_LOGIC_VECTOR(4 downto 0);
signal RD2_EX_MEM : STD_LOGIC_VECTOR(31 downto 0);  

signal ALUResOut : STD_LOGIC_VECTOR(31 downto 0);
signal MemData : STD_LOGIC_VECTOR(31 downto 0);

signal MemtoReg_MEM_WB : STD_LOGIC;
signal RegWrite_MEM_WB : STD_LOGIC;
signal ALURes_MEM_WB : STD_LOGIC_VECTOR(31 downto 0);
signal MemData_MEM_WB : STD_LOGIC_VECTOR(31 downto 0);
signal WA_MEM_WB : STD_LOGIC_VECTOR(4 downto 0);

signal mux : STD_LOGIC_VECTOR(31 downto 0);

begin
    Monopuls : MPG port map (en, btn(0), clk);
     
    Comand : IFetch port map (Jump, JumpAddress, PCSrc, BranchAddress_EX_MEM, en, btn(1), clk, PC, Instruction);
    
    JumpAddress <= PC_IF_ID(31 downto 28) & Instruction_IF_ID(25 downto 0) & "00";
    
    UnitControl : UC port map (Instruction_IF_ID(31 downto 26), RegDst, ExtOp, ALUSrc, Branch, Jump, ALUOp, MemWrite, MemtoReg, RegWrite);
    led(9 downto 0) <= ALUOp & RegDst & ExtOp & ALUSrc & Branch & Jump & MemWrite & MemtoReg & RegWrite;
    
    IDecoder : ID port map (RD1, RD2, Ext_Imm, func, sa, rt, rd, WD, Instruction_IF_ID(25 downto 0), WA_MEM_WB, clk, en, RegWrite_MEM_WB, ExtOp);
    
    UnitExecution : EX port map(RD1_ID_EX, RD2_ID_EX, Ext_Imm_ID_EX, ALUSrc_ID_EX, sa_ID_EX, func_ID_EX, ALUOp_ID_EX, PC_ID_EX, rt_ID_EX, rd_ID_EX, RegDst_ID_EX, ALURes, BranchAddress, Zero, rWA);
    PCSrc <= Branch_EX_MEM and Zero_EX_MEM;
    
    Memory : MEM port map(MemWrite_EX_MEM, ALURes_EX_MEM, RD2_EX_MEM, clk, en, MemData, ALUResOut);
    with MemtoReg_MEM_WB SELECT 
        WD <= ALURes_MEM_WB when '0',
              MemData_MEM_WB when '1',
              (others => '0') when others;
     
    process(clk)
    begin
        if rising_edge(clk) then
            if en = '1' then
                -- IF/ID
                Instruction_IF_ID <= Instruction;
                PC_IF_ID <= PC;
                
                -- ID/EX
                RegDst_ID_EX <= RegDst;
                ALUSrc_ID_EX <= ALUSrc;
                Branch_ID_EX <= Branch;
                ALUOp_ID_EX <= ALUOp;
                MemWrite_ID_EX <= MemWrite;
                MemtoReg_ID_EX <= MemtoReg;
                RegWrite_ID_EX <= RegWrite;
                RD1_ID_EX <= RD1;
                RD2_ID_EX <= RD2;
                Ext_Imm_ID_EX <= Ext_Imm;
                func_ID_EX <= func;
                sa_ID_EX <= sa;
                rd_ID_EX <= rd;
                rt_ID_EX <= rt;
                PC_ID_EX <= PC_IF_ID;
                
                -- EX/MEM
                Branch_EX_MEM <= Branch_ID_EX;
                MemWrite_EX_MEM <= MemWrite_ID_EX;
                MemtoReg_EX_MEM <= MemtoReg_ID_EX;
                RegWrite_EX_MEM <= RegWrite_ID_EX;
                Zero_EX_MEM <= Zero;
                BranchAddress_EX_MEM <= BranchAddress;
                ALURes_EX_MEM <= ALURes;
                WA_EX_MEM <= rWA;
                RD2_EX_MEM <= RD2_ID_EX; 
                
                -- MEM/WB
                MemtoReg_MEM_WB <= MemtoReg_EX_MEM;
                RegWrite_MEM_WB <= RegWrite_EX_MEM;
                ALURes_MEM_WB <= ALUResOut;
                MemData_MEM_WB <= MemData;
                WA_MEM_WB <= WA_EX_MEM;
            end if;
        end if;
    end process;
    
    with sw(7 downto 5) SELECT
        mux <= Instruction when "000",
               PC when "001",
               RD1_ID_EX when "010",
               RD2_ID_EX when "011",
               Ext_Imm_ID_EX when "100",
               ALURes when "101",
               MemData when "110",
               WD when "111",
               (others => '0') when others;
    
    Display : SSD port map (clk, mux, an, cat);
end Behavioral;