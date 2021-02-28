library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity Reg is
  Port ( dataIn  : in STD_LOGIC_VECTOR (15 downto 0);
         clk     : in STD_LOGIC;
         dataOut : out STD_LOGIC_VECTOR (15 downto 0));
end Reg;

architecture Behavioral of Reg is

begin

    process(clk)
        begin
        if falling_edge(clk) then
            dataOut <= dataIn;
        end if;
    end process;
    
end Behavioral;
