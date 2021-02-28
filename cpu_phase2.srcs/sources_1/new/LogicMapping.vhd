library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity LogicMapping is
  Port ( instIn  : in STD_LOGIC_VECTOR (3 downto 0);
         instDec : out STD_LOGIC_VECTOR (7 downto 0) );
end LogicMapping;

architecture Behavioral of LogicMapping is

begin

    instDec <= instIn & "0000";

end Behavioral;
