library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity control_unit_tb is
--  Port ( );
end control_unit_tb;

architecture Behavioral of control_unit_tb is

    component ControlUnit is
      Port ( opCode  : in STD_LOGIC_VECTOR (3 downto 0);
             clk     : in STD_LOGIC;
             signals : out STD_LOGIC_VECTOR (17 downto 0) );
    end component;
    
    signal opCodeIn    : STD_LOGIC_VECTOR (3 downto 0);
    signal contSignals : STD_LOGIC_VECTOR (17 downto 0);
    
    signal clock      : std_logic := '0';
    signal clk_period : time := 40 ns;
    
begin

     u1: ControlUnit
     Port Map ( opCode  => opCodeIn,
                clk     => clock,
                signals => contSignals );

    clk_process: process
    begin
        clock <= '0';
        wait for clk_period / 2;
        clock <= '1';
        wait for clk_period / 2;
    end process clk_process;
            
    test_bench: process
    begin
    
        opCodeIn <= "0001";
        wait for clk_period;
        wait for clk_period;
        wait for clk_period;
        wait for clk_period;
        wait for clk_period;
        
        opCodeIn <= "0010";
        wait for clk_period;
        wait for clk_period;
        wait for clk_period;
        wait for clk_period;
        wait for clk_period;
        
    end process test_bench;
    
end Behavioral;
