-- Vivado 2019.1
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity processor_tb is
--  Port ( );
end processor_tb;

architecture Behavioral of processor_tb is

    component Processor is
      Port ( clk  : in STD_LOGIC;
             swIn : in STD_LOGIC_VECTOR (15 downto 0);
             disp : out STD_LOGIC_VECTOR (15 downto 0) );
    end component;
    
    signal clock      : STD_LOGIC := '0';
    signal clk_period : time := 40 ns;
    signal switches   : STD_LOGIC_VECTOR (15 downto 0);
    signal display    : STD_LOGIC_VECTOR (15 downto 0);
    
begin

    u1: Processor Port Map ( clk  => clock,
                             swIn => switches,
                             disp => display );
    
    clk_process: process
    begin
        clock <= '0';
        wait for clk_period / 2;
        clock <= '1';
        wait for clk_period / 2;
    end process clk_process;

    test_bench: process
    begin
    
--        -- sw = 0, run 2000 ns
--        switches <= "0000000000000000";
--        wait for clk_period

--        -- sw = 1, run 2000 ns
--        switches <= "0000000000000001";
--        wait for clk_period;

--        -- sw = 3, run 4800 ns
--        switches <= "0000000000000011";
--        wait for clk_period;

--        -- sw = 5, run 8000 ns
--        switches <= "0000000000000101";
--        wait for clk_period;

        -- sw = 6, run for 9000 ns
        switches <= "0000000000000110";
        wait for clk_period;
    end process;
    
end Behavioral;
