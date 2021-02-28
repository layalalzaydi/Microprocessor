library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;

entity Incrementer is
  Port ( addrIn : in STD_LOGIC_VECTOR (7 downto 0);
         addrOut : out STD_LOGIC_VECTOR (7 downto 0) );
end Incrementer;

architecture Behavioral of Incrementer is

begin

    addrOut <= addrIn + '1';

end Behavioral;
