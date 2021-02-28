library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;

entity Memory is
  Port ( addr        : in  STD_LOGIC_VECTOR (15 downto 0);
         data        : in  STD_LOGIC_VECTOR (15 downto 0);
         sw          : in  STD_LOGIC_VECTOR (15 downto 0);
         clk, re, we : in  STD_LOGIC;
         dataOut     : out STD_LOGIC_VECTOR (15 downto 0);
         an, c, dp   : out STD_LOGIC_VECTOR (15 downto 0) );
end Memory;

architecture Behavioral of Memory is

    type memType is array (0 to 2**8) of STD_LOGIC_VECTOR (15 downto 0);
    
    signal mem: memType:= ( -- memory mapped I/O
                            "0000000000000000", -- 0, no op
                            "0000000000000000", -- 1, switches
                            "0000000000000000", -- 2, anodes
                            "0000000000000000", -- 3, display
                            "0000000000000000", -- 4, decimals
                            -- start
                            "0010" & "000" & "000" & "011111",      -- 5  addi $s0, $s0, start of array
                            "1000" & "010" & "101" & "000001",      -- 6  lw   $s5, 1($s2)
                            "0010" & "010" & "010" & "000001",      -- 7  addi $s2, $s2, 1
                            -- beq switches = 0 to print2
                            "1100" & "101" & "110" & "010011",      -- 8  beq  $s5, $s6, print2
                            -- beq switches = 1 to print1
                            "0010" & "110" & "110" & "000001",      -- 9  addi $s6, $s6, 1
                            "1100" & "101" & "110" & "001110",      -- 10 beq  $s5, $s6, print1
                            -- if switches > 1
                            "0010" & "110" & "110" & "000001",      -- 11 addi $s6, $s6, 1
                            "1001" & "000" & "010" & "000000",      -- 12 sw   $s2, 0($s0)
                            "1001" & "000" & "110" & "000001",      -- 13 sw   $s6, 1($s0)
                            "0001" & "110" & "110" & "110" & "000", -- 14 sub  $s6, $s6, $s6
                            "0010" & "101" & "001" & "111111",      -- 15 addi $s1, $s5, -1
                            -- loop
                            "1000" & "000" & "011" & "000000",      -- 16 lw   $s3, 0($s0)
                            "1000" & "000" & "100" & "000001",      -- 17 lw   $s4, 1($s0)
                            "1011" & "011" & "111" & "000001",      -- 18 sll  $s7, $s3, 1
                            "0011" & "111" & "100" & "010" & "000", -- 19 add  $s2, $s4, $s7
                            "1001" & "000" & "010" & "000010",      -- 20 sw   $s2, 2($s0)
                            "0010" & "000" & "000" & "000001",      -- 21 addi $s0, $s0, 1
                            "0010" & "001" & "001" & "111111",      -- 22 addi $s1, $s1, -1
                            "1101" & "001" & "110" & "111000",      -- 23 bne  $s1, $s6, loop
                            "1111" & "000000011100",                -- 24 jump print2
                            -- print1, seven seg, switches = 1
                            "0010" & "011" & "011" & "000010",      -- 25 addi $s3, $s3, 2
                            "1001" & "001" & "011" & "000011",      -- 26 sw   $s3, 3($s1)
                            "1111" & "000000011101",                -- 27 jump stop
                            -- print2, seven seg, switches = 0 or 1
                            "1001" & "001" & "010" & "000011",      -- 28 sw   $s2, 3($s1)
                            -- stop
                            "1111" & "000000011101",                -- 29 jump stop
                            others=> "0000000000000000" );
                           
    attribute ram_style : string;
    --attribute ram_style of mem : signal is "block";
    
begin

    an <= mem(2);
    c  <= mem(3);
    dp <= mem(4);
    
    process(clk)
    begin
        if(rising_edge(clk)) then
           if(we = '1') then
               if(conv_integer(addr) /= 1) then
                   mem(conv_integer(addr)) <= data;
               end if;    
           end if;
           if(re = '1') then
               dataOut <= mem(conv_integer(addr));
           end if;
           mem(1) <= sw;
        end if;
    end process;
    
end Behavioral;
