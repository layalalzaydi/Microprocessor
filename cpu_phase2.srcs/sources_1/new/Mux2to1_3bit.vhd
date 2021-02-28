library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity Mux2to1_3bit is
    Port ( A      : in STD_LOGIC_VECTOR (2 downto 0);
           B      : in STD_LOGIC_VECTOR (2 downto 0);
           sel    : in STD_LOGIC;
           muxOut : out STD_LOGIC_VECTOR (2 downto 0));
end Mux2to1_3bit;

architecture Behavioral of Mux2to1_3bit is

begin

    with sel select muxOut <=
        A when '0',
        B when '1',
        "000" when others;

end Behavioral;
