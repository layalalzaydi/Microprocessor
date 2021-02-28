library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_ARITH.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;

entity MicroCode is 
    generic ( Dwidth : integer := 21; -- Each location is 21 bits
              Awidth : integer := 8 ); -- 8 Address lines (256 locations)
              
    port ( addr : in std_logic_vector(Awidth-1 downto 0);
           dout : out std_logic_vector(Dwidth-1 downto 0)); -- Defaulting to outputting a fetch for initial startup
end MicroCode;

architecture Behavioural of MicroCode is

    type memType is array(0 to 2**Awidth-1) of std_logic_vector(Dwidth-1 downto 0);
    
    -- all locations initialized to zero
    signal memory: memType:= ( others => "000000000000000000000" ); -- no op 
    
    attribute ram_style: string;
    --attribute ram_style of memory : signal is "block";
                        
begin

    -- initializing microcode store
    -- steps 1 & 2, same for all instructions
    memory(0)  <= "101"&"0101001000"&"01"&"00"&"0000";  -- fetch
    memory(1)  <= "011"&"0000000000"&"10"&"00"&"0000";  -- decode
    
    -- R instructions
    memory(16)  <= "001"&"0000000001"&"00"&"00"&"0001"; -- sub ex
    memory(17)  <= "000"&"0000000100"&"00"&"00"&"0000"; -- sub mem
    
    memory(48)  <= "001"&"0000000001"&"00"&"00"&"0000"; -- add ex
    memory(49)  <= "000"&"0000000100"&"00"&"00"&"0000"; -- add mem
    
    memory(64)  <= "001"&"0000000001"&"00"&"00"&"0100"; -- AND ex
    memory(65)  <= "000"&"0000000100"&"00"&"00"&"0000"; -- AND mem
    
    memory(80)  <= "001"&"0000000001"&"00"&"00"&"0101"; -- OR ex
    memory(81)  <= "000"&"0000000100"&"00"&"00"&"0000"; -- OR mem
    
    memory(96)  <= "001"&"0000000001"&"00"&"00"&"0110"; -- XOR ex
    memory(97)  <= "000"&"0000000100"&"00"&"00"&"0000"; -- XOR mem
    
    memory(112) <= "001"&"0000000001"&"00"&"00"&"0111"; -- NOR ex
    memory(113) <= "000"&"0000000100"&"00"&"00"&"0000"; -- NOR mem
    
    memory(160) <= "001"&"0000000001"&"00"&"00"&"0010"; -- slt ex
    memory(161) <= "000"&"0000000100"&"00"&"00"&"0000"; -- slt mem
    
    memory(176) <= "001"&"0000000001"&"10"&"00"&"0011"; -- sll ex
    memory(177) <= "000"&"0000000110"&"00"&"00"&"0000"; -- sll mem
    
    -- memory instructions
    memory(128) <= "001"&"0000000001"&"10"&"00"&"0000"; -- lw ex
    memory(129) <= "001"&"0011000000"&"00"&"00"&"0000"; -- lw mem
    memory(130) <= "000"&"0000010110"&"00"&"00"&"0000"; -- lw wb
    
    memory(144) <= "001"&"0000000001"&"10"&"00"&"0000"; -- sw ex
    memory(145) <= "000"&"0010100000"&"00"&"00"&"0000"; -- sw mem
    
    -- immediate instructions
    memory(32)  <= "001"&"0000000001"&"10"&"00"&"0000"; -- addi ex
    memory(33)  <= "000"&"0000000110"&"00"&"00"&"0000"; -- addi mem
    
    -- branch instructions
    memory(192) <= "000"&"1000000001"&"00"&"01"&"1110"; -- beq ex
    
    memory(208) <= "000"&"1000000001"&"00"&"01"&"1111"; -- bne ex
    
    -- jump instruction
    memory(240) <= "000"&"0100000000"&"00"&"10"&"0000"; -- jump ex
    
    dout <= memory(conv_integer(addr));
    
end Behavioural;   