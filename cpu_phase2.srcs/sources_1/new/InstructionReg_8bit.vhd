library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity InstructionReg_8bit is
  Port ( opIn    : in STD_LOGIC_VECTOR (3 downto 0);
         clk, en : in STD_LOGIC;
         opOut   : out STD_LOGIC_VECTOR (3 downto 0) );
end InstructionReg_8bit;

architecture Behavioral of InstructionReg_8bit is

signal currOp : STD_LOGIC_VECTOR (3 downto 0) := opIn;

begin

    process(clk)
    begin  
        if (rising_edge(CLK)) then
            if (en = '1') then
                currOp <= opIn;
            end if;
            opOut <= currOp;
        end if;
    end process;

end Behavioral;
