library IEEE;

use IEEE.STD_LOGIC_1164.ALL;

entity Mux3to1_8bit is
    Port ( zeros    : in STD_LOGIC_VECTOR (7 downto 0) := "00000000";
           nextAddr : in STD_LOGIC_VECTOR (7 downto 0);
           newAddr  : in STD_LOGIC_VECTOR (7 downto 0);
           sel      : in STD_LOGIC_VECTOR (1 downto 0);
           addrOut  : out STD_LOGIC_VECTOR (7 downto 0)  );
end Mux3to1_8bit;

architecture Behavioral of Mux3to1_8bit is

begin

    addrOut <= zeros    when sel = "00" else
               nextAddr when sel = "01" else
               zeros    when sel = "10" else
               newAddr  when sel = "11";
               
end Behavioral;
