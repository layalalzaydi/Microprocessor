library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;

entity ALU is

    Port ( IN1, IN2 : in STD_LOGIC_VECTOR (15 downto 0);
           ALUop    : in STD_LOGIC_VECTOR (3 downto 0);
           dataOut  : out STD_LOGIC_VECTOR (15 downto 0);
           Zero     : out STD_LOGIC;
           OVF      : out STD_LOGIC );
           
end ALU;

architecture Behavioural of ALU is
    
begin
    
    process (ALUop, IN1, IN2)
    variable tempSum : STD_LOGIC_VECTOR (17 downto 0);
    variable compIn2 : STD_LOGIC_VECTOR (15 downto 0);
    begin
        case ALUop is
            when "0100" => -- AND
            
                OVF  <= '0';
                Zero <= '0';
                dataOut <= IN1 AND IN2;
                
            when "0101" => -- OR
            
                OVF  <= '0';
                Zero <= '0';
                dataOut <= IN1 OR IN2;
                
            when "0110" => -- XOR
            
                OVF  <= '0';
                Zero <= '0';
                dataOut <= IN1 XOR IN2;
                
            when "0111" => -- NOR 
            
                OVF  <= '0';
                Zero <= '0';
                dataOut <= IN1 NOR IN2;               
                
            when "0000" => -- signed addition
                
                OVF  <= '0';
                Zero <= '0';
--                for i in 0 to 14 loop -- ones comp of input 1 if neg
--                    compIn1(i) <= IN1(15) XOR IN1(i);
--                end loop;
--                compIn1 <= compIn1 + IN1(15); -- 2s comp if neg
                
--                for i in 0 to 14 loop -- ones comp of input 2 if neg
--                    compIn2(i) <= IN2(15) XOR IN2(i);
--                end loop;
--                compIn2 <= compIn2 + IN2(15); -- 2s comp if neg
                
                --tempSum <= STD_LOGIC_VECTOR(resize(UNSIGNED(compIn1), 18) + resize(UNSIGNED(compIn2), 18));
                tempSum := STD_LOGIC_VECTOR(resize(UNSIGNED(IN1), 18) + resize(UNSIGNED(IN2), 18));
                dataOut <= tempSum(15 downto 0);
                OVF <= tempSum(17) OR tempSum(16);
                
                if((IN1(15) = IN2(7)) and (tempSum(15) /= IN1(15))) then
                    OVF <= '1';
                end if;
                
            when "0001" => -- signed subtract
            
                OVF  <= '0';
                Zero <= '0';
                
                compIn2 := NOT IN2;   -- ones comp of in2
                compIn2 := compIn2 + '1'; -- 2s comp of in2
                
                tempSum := STD_LOGIC_VECTOR(resize(UNSIGNED(IN1), 18) + resize(UNSIGNED(compIn2), 18));
                dataOut <= tempSum(15 downto 0);
                OVF <= tempSum(17) OR tempSum(16);
                
                if((IN1(15) = compIn2(15)) and (tempSum(15) /= IN1(15))) then
                    OVF <= '1';
                end if;
                
            when "0010" => -- set less than, signed
            
                OVF  <= '0';
                Zero <= '0';
                
                if(STD_LOGIC_VECTOR(SIGNED(IN1)) < STD_LOGIC_VECTOR(SIGNED(IN2))) then
                    Zero <= '1';
                else
                    Zero <= '0';
                end if;
                
                dataOut <= "0000000000000000";

            when "0011" => -- shift left logical
            
                OVF <= '0';
                Zero <= '0';
                
                dataOut <= STD_LOGIC_VECTOR(UNSIGNED(IN1) sll conv_integer(IN2));
                                    
            when "1110" => -- branch if equal
            
                OVF  <= '0';
                Zero <= '0';
                if(IN1 = IN2) then
                    Zero <= '1';
                else
                    Zero <= '0';
                end if; 
                
                dataOut <= "0000000000000000";

            when "1111" => -- branch if not equal
            
                OVF  <= '0';
                Zero <= '0';
                
                if(IN1 = IN2) then
                    Zero <= '0';
                else
                    Zero <= '1';
                end if; 
                
                dataOut <= "0000000000000000";
                                
             when others  =>
                 OVF  <= '0';
                 Zero <= '0';
                 dataOut <= "0000000000000000";                 
        end case;
    end process;
    
end Behavioural;
