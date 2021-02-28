library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;

entity ControlUnit is
  Port ( opCode  : in STD_LOGIC_VECTOR (3 downto 0);
         clk     : in STD_LOGIC;
         signals : out STD_LOGIC_VECTOR (17 downto 0) );
end ControlUnit;

architecture Behavioral of ControlUnit is
    
--    component InstructionReg_8bit is
--        Port ( opIn    : in STD_LOGIC_VECTOR (3 downto 0);
--               clk, en : in STD_LOGIC;
--               opOut   : out STD_LOGIC_VECTOR (3 downto 0) );
--    end component;
    
    component Incrementer is
        Port ( addrIn : in STD_LOGIC_VECTOR (7 downto 0);
               addrOut : out STD_LOGIC_VECTOR (7 downto 0) );
    end component;

    component LogicMapping is
        Port ( instIn  : in STD_LOGIC_VECTOR (3 downto 0);
               instDec : out STD_LOGIC_VECTOR (7 downto 0) );
    end component;

    component Mux3to1_8bit is
        Port ( zeros    : in STD_LOGIC_VECTOR (7 downto 0) := "00000000";
               nextAddr : in STD_LOGIC_VECTOR (7 downto 0);
               newAddr  : in STD_LOGIC_VECTOR (7 downto 0);
               sel      : in STD_LOGIC_VECTOR (1 downto 0);
               addrOut  : out STD_LOGIC_VECTOR (7 downto 0)  );
    end component;
    
    component MicroPCReg is
        port ( PCin  : in STD_LOGIC_VECTOR (7 downto 0);
               clk   : in STD_LOGIC;
               PCout : out STD_LOGIC_VECTOR (7 downto 0));
    end component;
    
    component MicroCode is 
        generic ( Dwidth : integer := 21;
                  Awidth : integer := 8 );
                  
        port    ( addr: in std_logic_vector(Awidth-1 downto 0);
                  dout: out std_logic_vector(Dwidth-1 downto 0) );
    end component;
    
    --signal decoderIn  : STD_LOGIC_VECTOR (3 downto 0);
    signal regEn      : STD_LOGIC;
    signal decoderOut : STD_LOGIC_VECTOR (7 downto 0);
    signal nextPC     : STD_LOGIC_VECTOR (7 downto 0);
    signal muxSel     : STD_LOGIC_VECTOR (1 downto 0);
    signal pcRegIn    : STD_LOGIC_VECTOR (7 downto 0);
    signal codeAddr   : STD_LOGIC_VECTOR (7 downto 0);
    signal microOpOut : STD_LOGIC_VECTOR (20 downto 0);
    
begin

--    InstReg: component InstructionReg_8bit
--        Port Map ( opIn  => opCode,
--                   clk   => clk,
--                   en    => regEn,
--                   opOut => decoderIn );
                   
    Decoder: component LogicMapping
        Port Map ( instIn  => opCode,
                   instDec => decoderOut );
                   
     Mux : component Mux3to1_8bit
        Port Map ( zeros    => "00000000",
                   nextAddr => nextPC,
                   newAddr  => decoderOut,
                   sel      => muxSel,
                   addrOut  => pcRegIn );      
                   
    PCReg : component MicroPCReg
        Port Map ( PCin  => pcregIn,
                   clk   => clk,
                   PCout => codeAddr );
                   
    MicroOpStore: component MicroCode
        Port Map ( addr => codeAddr,
                   dout => microOpOut ); 
                   
    Incr : component Incrementer
        Port Map ( addrIn  => codeAddr,
                   addrOut => nextPC );             
                   
    --regEn   <= microOpOut(20); 
    muxSel  <= microOpOut(19 downto 18);
    signals <= microOpOut(17 downto 0);    
                                                                            
end Behavioral;
