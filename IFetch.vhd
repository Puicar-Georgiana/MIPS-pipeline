library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;

entity IFetch is
    Port (Jump: in STD_LOGIC;
          JumpAddress : in STD_LOGIC_VECTOR(31 downto 0);
          PCSrc: in STD_LOGIC;
          BranchAddress: in STD_LOGIC_VECTOR(31 downto 0);
          En: in STD_LOGIC;
          RST: in STD_LOGIC;
          clk: in STD_LOGIC;
          PC: out STD_LOGIC_VECTOR(31 downto 0);
          Instruction: out STD_LOGIC_VECTOR(31 downto 0));
end IFetch;

architecture Behavioral of IFetch is
type rom_t is array(0 to 63) of STD_LOGIC_VECTOR(31 downto 0);
signal mem: rom_t := (
-- INIT
B"100011_00000_00011_0000000000000000", -- 00: 0x8C030000  LW $3, 0($0)        -- $3 <- mem[0] (incarca adresa vectorului A)
B"100011_00000_00010_0000000000000100", -- 01: 0x8C020004  LW $2, 4($0)        -- $2 <- mem[4] (incarca numarul de elemente N)
B"001000_00000_00110_0000000000000001", -- 02: 0x20060001  ADDI $6, $0, 1      -- $6 <- 1 (presupunem ca sirul este ordonat)
B"001000_00000_00001_0000000000000000", -- 03: 0x20010000  ADDI $1, $0, 0      -- $1 <- 0 (index i)
B"001000_00010_01000_1111111111111111", -- 04: 0x2048FFFF  ADDI $8, $2, -1     -- $8 <- N - 1
B"000000_00000_00000_00000_00000_000000", -- 05: 0x00000000  NOOP               
B"000000_00000_00000_00000_00000_000000", -- 06: 0x00000000  NOOP               

-- LOOP
B"000100_00001_01000_0000000000010101", -- 07: 0x10280015  BEQ $1, $8, +21     -- daca $1 = $8 sari la FINISH
B"000000_00000_00000_00000_00000_000000", -- 08: 0x00000000  NOOP
B"000000_00000_00000_00000_00000_000000", -- 09: 0x00000000  NOOP
B"000000_00000_00000_00000_00000_000000", -- 0A: 0x00000000  NOOP
B"000000_00001_00000_00010_00000_000100", -- 0B: 0x00011080  SLL $2, $1, 2       -- $2 <- i * 4 (offset)
B"000000_00000_00000_00000_00000_000000", -- 0C: 0x00000000  NOOP
B"000000_00000_00000_00000_00000_000000", -- 0D: 0x00000000  NOOP
B"000000_00011_00010_00011_00000_100000", -- 0E: 0x00621820  ADD $3, $3, $2      -- $3 <- A + i * 4
B"000000_00000_00000_00000_00000_000000", -- 0F: 0x00000000  NOOP
B"000000_00000_00000_00000_00000_000000", -- 10: 0x00000000  NOOP
B"100011_00011_00100_0000000000000000", -- 11: 0x8C640000  LW $4, 0($3)        -- $4 <- A[i]
B"100011_00011_00101_0000000000000100", -- 12: 0x8C650004  LW $5, 4($3)        -- $5 <- A[i+1]
B"000000_00000_00000_00000_00000_000000", -- 13: 0x00000000  NOOP
B"000000_00000_00000_00000_00000_000000", -- 14: 0x00000000  NOOP
B"000000_00100_00101_00100_00000_101010", -- 15: 0x0085202A  SLT $4, $4, $5      -- $4 <- (A[i] < A[i+1]) ? 1 : 0
B"000000_00000_00000_00000_00000_000000", -- 16: 0x00000000  NOOP
B"000000_00000_00000_00000_00000_000000", -- 17: 0x00000000  NOOP
B"000100_00100_00000_0000000000000101", -- 18: 0x10800005  BEQ $4, $0, +5      -- daca A[i] >= A[i+1] sari la SET0
B"000000_00000_00000_00000_00000_000000", -- 19: 0x00000000  NOOP
B"000000_00000_00000_00000_00000_000000", -- 1A: 0x00000000  NOOP
B"000000_00000_00000_00000_00000_000000", -- 1B: 0x00000000  NOOP
B"000010_00000_00000_0000000000000101", -- 1C: 0x08000005  J 5                 -- sari la inceputul LOOP
B"001000_00001_00001_0000000000000001", -- 1D: 0x20210001  ADDI $1, $1, 1      -- i++

-- SET0
B"001000_00000_00110_0000000000000000", -- 1E: 0x20060000  ADDI $6, $0, 0      -- sirul nu este ordonat
B"000000_00000_00000_00000_00000_000000", -- 1F: 0x00000000  NOOP
B"000000_00000_00000_00000_00000_000000", -- 20: 0x00000000  NOOP

-- FINISH
B"101011_00000_00110_0000000000001000", -- 21: 0xAC060008  SW $6, 8($0)        -- mem[8] <- $6 (scrie rezultatul)

others => (others => '0')
);

signal Q : STD_LOGIC_VECTOR(31 downto 0);
signal D : STD_LOGIC_VECTOR(31 downto 0);
signal Mux1 : STD_LOGIC_VECTOR(31 downto 0);

begin
    process(clk, RST)
    begin
        if RST = '1' then Q <= (others => '0');
        elsif rising_edge(clk) then 
            if En = '1' then Q <= D;
            end if;
        end if;     
    end process;
    
    PC <= Q + X"00000004";  

    with PCSrc SELECT 
        Mux1 <= Q + 4 when '0',
        BranchAddress when '1', 
        (others => '0') when others;
    
    with Jump SELECT
        D <= Mux1 when '0',
        JumpAddress when '1',
        (others => '0') when others;
    
    Instruction <= mem(conv_integer(Q(7 downto 2)));
end Behavioral;