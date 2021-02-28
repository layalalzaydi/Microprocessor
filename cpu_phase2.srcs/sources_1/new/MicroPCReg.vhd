library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_ARITH.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;

entity MicroPCReg is
    port ( PCin  : in STD_LOGIC_VECTOR (7 downto 0);
           clk   : in STD_LOGIC;
           PCout : out STD_LOGIC_VECTOR (7 downto 0) := "00000000");
end MicroPCReg;

architecture Behavioural of MicroPCReg is

    --signal currPC : STD_LOGIC_VECTOR (7 downto 0) := "00000000";
                        
begin

    process(clk)
    begin
        if(falling_edge(clk)) then
            --currPC <= PCin;
            --PCout  <= currPc;
            PCout <= PCin;
        end if;
    end process;

end Behavioural;   