library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity PC is
  Port ( nextPC  : in STD_LOGIC_VECTOR (15 downto 0);
         clk, en : in STD_LOGIC;
         PCout   : out STD_LOGIC_VECTOR (15 downto 0));
end PC;

architecture Behavioral of PC is

signal currPC : STD_LOGIC_VECTOR (15 downto 0) := "0000000000000101";

begin

    process(clk, currPC)
    begin
        if(rising_edge(clk)) then
            if(en = '1') then
                currPC <= nextPC;
            end if;
        end if;
        PCout <= currPC;
    end process;

end Behavioral;
