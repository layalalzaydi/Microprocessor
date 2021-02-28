library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity Mux3to1_16bit is
  Port ( A      : in STD_LOGIC_VECTOR (15 downto 0);
         B      : in STD_LOGIC_VECTOR (15 downto 0);
         C      : in STD_LOGIC_VECTOR (15 downto 0);
         sel    : in STD_LOGIC_VECTOR (1 downto 0);
         muxOut : out STD_LOGIC_VECTOR (15 downto 0));
end Mux3to1_16bit;

architecture Behavioral of Mux3to1_16bit is

begin

    with sel select muxOut <=
        A when "00",
        B when "01",
        C when "10",
        "0000000000000000" when others;

end Behavioral;
