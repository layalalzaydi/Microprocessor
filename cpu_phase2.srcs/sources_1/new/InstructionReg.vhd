library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity InstructionReg is
  Port ( instIn  : in STD_LOGIC_VECTOR (15 downto 0);
         clk, we : in STD_LOGIC;
         instOut : out STD_LOGIC_VECTOR (15 downto 0));
end InstructionReg;

architecture Behavioral of InstructionReg is

begin

    process(clk)
    begin
        if(falling_edge(clk)) then
            if(we = '1') then
                instOut <= instIn;
            end if;
        end if;
    end process;    

end Behavioral;
