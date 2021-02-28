library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;

entity RegisterFile is
  Port ( addr1   : in  STD_LOGIC_VECTOR (2 downto 0);
         addr2   : in  STD_LOGIC_VECTOR (2 downto 0);
         addrWr  : in  STD_LOGIC_VECTOR (2 downto 0);
         data    : in  STD_LOGIC_VECTOR (15 downto 0); 
         clk, we : in  STD_LOGIC;
         data1   : out STD_LOGIC_VECTOR (15 downto 0);
         data2   : out STD_LOGIC_VECTOR (15 downto 0));
end RegisterFile;

architecture Behavioral of RegisterFile is

    type memType is array (0 to 8) of STD_LOGIC_VECTOR (15 downto 0);
    
    signal regs: memType:= ( others=> "0000000000000000" ); -- 8 general purpose regs
                           
    attribute ram_style : string;
    attribute ram_style of regs : signal is "block";

begin
    
    process(clk, addr1, addr2)
    begin
        if(rising_edge(clk)) then
           if(we = '1') then
                regs(conv_integer(addrWr)) <= data;
           end if;
        end if;
        data1 <= regs(conv_integer(addr1));
        data2 <= regs(conv_integer(addr2));
    end process;
    
end Behavioral;
