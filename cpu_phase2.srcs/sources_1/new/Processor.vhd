-- Vivado 2019.1
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_ARITH.ALL;

entity Processor is
  Port ( clk  : in STD_LOGIC;
         swIn : in STD_LOGIC_VECTOR (15 downto 0);
         disp : out STD_LOGIC_VECTOR (15 downto 0) );
end Processor;

architecture Behavioral of Processor is
    
--    signal clk : STD_LOGIC := '1';
    
    component Memory is
      Port ( addr        : in  STD_LOGIC_VECTOR (15 downto 0);
             data        : in  STD_LOGIC_VECTOR (15 downto 0);
             sw          : in  STD_LOGIC_VECTOR (15 downto 0);
             clk, re, we : in  STD_LOGIC;
             dataOut     : out STD_LOGIC_VECTOR (15 downto 0);
             an, c, dp   : out STD_LOGIC_VECTOR (15 downto 0) );
    end component;
    
    component RegisterFile is
        Port ( addr1   : in  STD_LOGIC_VECTOR (2 downto 0);
               addr2   : in  STD_LOGIC_VECTOR (2 downto 0);
               addrWr  : in  STD_LOGIC_VECTOR (2 downto 0);
               data    : in  STD_LOGIC_VECTOR (15 downto 0); 
               clk, we : in  STD_LOGIC;
               data1   : out STD_LOGIC_VECTOR (15 downto 0);
               data2   : out STD_LOGIC_VECTOR (15 downto 0));
    end component;

    component ControlUnit is
      Port ( opCode  : in STD_LOGIC_VECTOR (3 downto 0);
             clk     : in STD_LOGIC;
             signals : out STD_LOGIC_VECTOR (17 downto 0) );
    end component;
    
    component PC is
        Port ( nextPC  : in STD_LOGIC_VECTOR (15 downto 0);
               clk, en : in STD_LOGIC;
               PCout   : out STD_LOGIC_VECTOR (15 downto 0) );
    end component;
    
    component Reg is
        Port ( dataIn  : in STD_LOGIC_VECTOR (15 downto 0);
               clk     : in STD_LOGIC;
               dataOut : out STD_LOGIC_VECTOR (15 downto 0) );
    end component;
    
    component ALU is
        Port ( IN1, IN2 : in STD_LOGIC_VECTOR (15 downto 0);
               ALUop    : in STD_LOGIC_VECTOR (3 downto 0);
               dataOut  : out STD_LOGIC_VECTOR (15 downto 0);
               Zero     : out STD_LOGIC;
               OVF      : out STD_LOGIC );
    end component;
    
    component InstructionReg is
        Port ( instIn  : in STD_LOGIC_VECTOR (15 downto 0);
               clk, we : in STD_LOGIC;
               instOut : out STD_LOGIC_VECTOR (15 downto 0) );
    end component;
    
    component Mux2to1_16bit is
        Port ( A      : in STD_LOGIC_VECTOR (15 downto 0);
               B      : in STD_LOGIC_VECTOR (15 downto 0);
               sel    : in STD_LOGIC;
               muxOut : out STD_LOGIC_VECTOR (15 downto 0) );
    end component;
    
    component Mux3to1_16bit is
        Port ( A      : in STD_LOGIC_VECTOR (15 downto 0);
               B      : in STD_LOGIC_VECTOR (15 downto 0);
               C      : in STD_LOGIC_VECTOR (15 downto 0);
               sel    : in STD_LOGIC_VECTOR (1 downto 0);
               muxOut : out STD_LOGIC_VECTOR (15 downto 0) );
    end component;
    
    component Mux2to1_3bit is
        Port ( A      : in STD_LOGIC_VECTOR (2 downto 0);
               B      : in STD_LOGIC_VECTOR (2 downto 0);
               sel    : in STD_LOGIC;
               muxOut : out STD_LOGIC_VECTOR (2 downto 0));
    end component;
    
    -- signals
    signal pcEn        : STD_LOGIC;
    signal pcOut       : STD_LOGIC_VECTOR (15 downto 0);
    signal nextPC      : STD_LOGIC_VECTOR (15 downto 0);
    
    signal contSignal  : STD_LOGIC_VECTOR (17 downto 0);
    
    signal regData1    : STD_LOGIC_VECTOR (15 downto 0);
    signal AregOut     : STD_LOGIC_VECTOR (15 downto 0);
    
    signal regData2    : STD_LOGIC_VECTOR (15 downto 0);
    signal BregOut     : STD_LOGIC_VECTOR (15 downto 0);
    
    signal ALURegIn    : STD_LOGIC_VECTOR (15 downto 0);
    signal ALURegOut   : STD_LOGIC_VECTOR (15 downto 0);
    signal ALUzero     : STD_LOGIC;
    signal ALUinA      : STD_LOGIC_VECTOR (15 downto 0);
    signal ALUinB      : STD_LOGIC_VECTOR (15 downto 0);
    signal ovfFlag     : STD_LOGIC;
    
    signal memoryOut   : STD_LOGIC_VECTOR (15 downto 0);
    signal memAddrIn   : STD_LOGIC_VECTOR (15 downto 0);
    
    signal regWrAddr   : STD_LOGIC_VECTOR (2 downto 0);
    signal regWrData   : STD_LOGIC_VECTOR (15 downto 0);
    
    signal IRout       : STD_LOGIC_VECTOR (15 downto 0);
    signal MDRout      : STD_LOGIC_VECTOR (15 downto 0);
    
    signal signExtend  : STD_LOGIC_VECTOR (15 downto 0);
    signal IRextended  : STD_LOGIC_VECTOR (15 downto 0);
    signal wrAddrMux_A : STD_LOGIC_VECTOR (15 downto 0);
    signal wrAddrMux_B : STD_LOGIC_VECTOR (15 downto 0);
    
    signal anodes      : STD_LOGIC_VECTOR (15 downto 0);
    signal dps         : STD_LOGIC_VECTOR (15 downto 0);
    
begin

    AReg : component Reg
        Port Map ( dataIn  => regData1,
                   clk     => clk,
                   dataOut => ARegOut );
                   
    BReg : component Reg
        Port Map ( dataIn  => regData2,
                   clk     => clk,
                   dataOut => BRegOut );
                   
    ALUout : component Reg
        Port Map ( dataIn  => ALURegIn,
                   clk     => clk,
                   dataOut => ALURegOut );
                   
    IR : component InstructionReg
      Port Map( instIn  => memoryOut,
                clk     => clk,
                we      => contSignal(11),
                instOut => IRout );
                   
    MDR : component Reg
        Port Map ( dataIn  => memoryOut,
                   clk     => clk,
                   dataOut => MDRout );
                   
    PCen <= contSignal(16) OR (ALUzero AND contSignal(17));               
    PCMap : component PC
        Port Map ( nextPC => nextPC,
                   clk    => clk,
                   en     => PCen,
                   PCout  => pcOut );                
    
    PCMux : component Mux2to1_16bit
        Port Map ( A      => pcOut,
                   B      => ALUregOut,
                   sel    => contSignal(15),
                   muxOut => memAddrIn );  
                   
    MemMap : component Memory
        Port Map ( addr    => memAddrIn,
                   data    => BRegOut,
                   sw      => swIn,
                   clk     => clk,
                   re      => contSignal(14),
                   we      => contSignal(13),
                   dataOut => memoryOut,
                   an      => anodes,
                   c       => disp,
                   dp      => dps );

    ControlMap : component ControlUnit
      Port Map ( opCode  => IRout(15 downto 12),
                 clk     => clk,
                 signals => contSignal );
                     
    WrAddrMux : component Mux2to1_3bit
        Port Map ( A      => IRout(5 downto 3),
                   B      => IRout(8 downto 6),
                   sel    => contSignal(9),
                   muxOut => regWrAddr );
                   
    WrDataMux : component Mux2to1_16bit
        Port Map ( A      => ALURegOut,
                   B      => MDRout,
                   sel    => contSignal(12),
                   muxOut => regWrData );
                   
    RegFile : component RegisterFile
        Port map ( addr1  => IRout(11 downto 9),
                   addr2  => IRout(8 downto 6),
                   addrWr => regWrAddr,
                   data   => regWrData,
                   clk    => clk,
                   we     => contSignal(10),
                   data1  => regData1,
                   data2  => regData2 );
                   
    ALUMux1 : component Mux2to1_16bit
        Port Map ( A      => PCout,
                   B      => ARegOut,
                   sel    => contSignal(8),
                   muxOut => ALUinA );
                   
    signExtend <= (15 downto 5 => IRout(5)) & IRout(4 downto 0);
    ALUMux2 : component Mux3to1_16bit
        Port Map ( A      => BRegOut,
                   B      => "0000000000000001",
                   C      => signExtend,
                   sel    => contSignal(7 downto 6),
                   muxOut => ALUinB ); 
                   
    ALUmap : component ALU
        Port Map ( IN1     => ALUinA,
                   IN2     => ALUinB,
                   ALUop   => contSignal(3 downto 0),
                   dataOut => ALURegIn,
                   Zero    => ALUzero,
                   OVF     => OVFFlag );
                   
    IRextended <= "0000" & IRout(11 downto 0);          
    PCMux3ot1 : component Mux3to1_16bit
        Port Map ( A      => ALURegIn,
                   B      => ALURegOut,
                   C      => IRextended,
                   sel    => contSignal(5 downto 4),
                   muxOut => nextPC );                                                   
                                                                         
end Behavioral;
