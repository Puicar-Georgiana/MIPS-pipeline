library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;

entity EX is
    Port ( RD1 : in STD_LOGIC_VECTOR (31 downto 0);
           RD2 : in STD_LOGIC_VECTOR (31 downto 0);
           sa: in STD_LOGIC_VECTOR (4 downto 0);
           func: in STD_LOGIC_VECTOR (5 downto 0);
           ALUOp : in STD_LOGIC_VECTOR (1 downto 0);
           PC: in STD_LOGIC_VECTOR (31 downto 0);
           Ext_imm : in STD_LOGIC_VECTOR (31 downto 0);
           ALUSrc : in STD_LOGIC;
           rt: in STD_LOGIC_VECTOR (4 downto 0);
           rd: in STD_LOGIC_VECTOR (4 downto 0);
           RegDst: in STD_LOGIC;
           ALURes: out STD_LOGIC_VECTOR (31 downto 0);
           BranchAddress : out STD_LOGIC_VECTOR (31 downto 0);
           Zero: out STD_LOGIC;
           rWA: out STD_LOGIC_VECTOR(4 downto 0));
end EX;

architecture Behavioral of EX is

signal C : STD_LOGIC_VECTOR(31 downto 0);
signal B : STD_LOGIC_VECTOR(31 downto 0);
signal A : STD_LOGIC_VECTOR(31 downto 0);
signal aux : STD_LOGIC_VECTOR(31 downto 0);
signal ALUCtrl : STD_LOGIC_VECTOR(2 downto 0);

begin
    ControlALU : process(ALUOp, func)
    begin
        case ALUOp is 
            when "00" => 
                case func is
                    when "000000" => ALUCtrl <= "000";
                    when "000001" => ALUCtrl <= "001";
                    when "000010" => ALUCtrl <= "010";
                    when "000011" => ALUCtrl <= "011";
                    when "000100" => ALUCtrl <= "100";
                    when "000101" => ALUCtrl <= "101";
                    when "000110" => ALUCtrl <= "110";
                    when "000111" => ALUCtrl <= "111";
                    when others => ALUCtrl <= (others => 'X');
                end case;
            when "01" => ALUCtrl <= "000";
            when "10" => ALUCtrl <= "001";
            when "11" => ALUCtrl <= "101";
            when others => ALUCtrl <= (others => 'X');    
        end case;
    end process;
    
    A <= RD1;
    with ALUSrc SELECT B <= RD2 when '0',
                            Ext_imm when '1',
                            (others => '0') when others;
                            
    UnitALU : process(ALUCtrl, A, B, sa)
    begin
        case ALUCtrl is
            when "000" => C <= A + B;
            when "001" => C <= A - B;
            when "010" => C <= to_stdlogicvector(to_bitvector(B) sll conv_integer(sa));
            when "011" => C <= to_stdlogicvector(to_bitvector(B) srl conv_integer(sa));
            when "100" => C <= A and B;
            when "101" => C <= A or B;
            when "110" => C <= A xor B;
            when "111" => if (signed(A) < signed(B)) then C <= X"00000001";
                                                     else C <= X"00000000";
                          end if;                           
            when others => C <= (others => 'X');                
        end case;
    end process;                 
    ALURes <= C;
    
   Zero <= '1' when C = X"00000000" else '0';  
    
    aux<= Ext_imm(29 downto 0) & "00";
    BranchAddress<= aux + PC;
    
    rWA <= rt when RegDst = '0' else rd;
                                                                      
end Behavioral;