--------------------------------------------------------------------------------
-- Company: 
-- Engineer:
--
-- Create Date:   17:56:05 05/15/2024
-- Design Name:   
-- Module Name:   C:/Users/javie/OneDrive/Escritorio/micro/pryoecto/test.vhd
-- Project Name:  pryoecto
-- Target Device:  
-- Tool versions:  
-- Description:   
-- 
-- VHDL Test Bench Created by ISE for module: project
-- 
-- Dependencies:
-- 
-- Revision:
-- Revision 0.01 - File Created
-- Additional Comments:
--
-- Notes: 
-- This testbench has been automatically generated using types std_logic and
-- std_logic_vector for the ports of the unit under test.  Xilinx recommends
-- that these types always be used for the top-level I/O of a design in order
-- to guarantee that the testbench will bind correctly to the post-implementation 
-- simulation model.
--------------------------------------------------------------------------------
LIBRARY ieee;
USE ieee.std_logic_1164.ALL;
 
-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--USE ieee.numeric_std.ALL;
 
ENTITY test IS
END test;
 
ARCHITECTURE behavior OF test IS 
 
    -- Component Declaration for the Unit Under Test (UUT)
 
    COMPONENT project
    PORT(
         Rx_in : IN  std_logic;
         baud_sel : IN  std_logic;
         clk : IN  std_logic;
         reset : IN  std_logic;
         Rx_data : OUT  std_logic_vector(7 downto 0);
         RX_newdata : OUT  std_logic;
         Rx_error : OUT  std_logic
        );
    END COMPONENT;
    

   --Inputs
   signal Rx_in : std_logic := '1';
   signal baud_sel : std_logic := '0';
   signal clk : std_logic := '0';
   signal reset : std_logic := '0';

 	--Outputs
   signal Rx_data : std_logic_vector(7 downto 0);
   signal RX_newdata : std_logic;
   signal Rx_error : std_logic;

   -- Clock period definitions 
   constant clk_period : time := 20 ns;
 
BEGIN
 
	-- Instantiate the Unit Under Test (UUT)
   uut: project PORT MAP (
          Rx_in => Rx_in,
          baud_sel => baud_sel,
          clk => clk,
          reset => reset,
          Rx_data => Rx_data,
          RX_newdata => RX_newdata,
          Rx_error => Rx_error
        );

   -- Clock process definitions
   clk_process :process
   begin
		clk <= '0';
		wait for clk_period/2;
		clk <= '1';
		wait for clk_period/2;
   end process;
 

   -- Stimulus process
   stim_proc: process
   begin		
		reset<='1';
      wait for 1 ms;	
		reset<='0'; 
        
		 wait for 1ms;
		 baud_sel<='0';
		 wait for 20ns;
		 Rx_in<='0'; --- inicio  RXNbit=0
		 wait for 104166 ns;	
	
		 Rx_in<='1'; ---1bit 	RXNbit=1		
		 wait for 104166 ns;
		 
		 Rx_in<='1'; ---2bit 	RXNbit=2
		 wait for 104166 ns;
		 
		 Rx_in<='0'; ---3bit 	RXNbit=3
		 wait for 104166 ns;
		 
		 
		 Rx_in<='0'; ---4bit 	RXNbit=4
		 wait for 104166 ns;
		 
		 Rx_in<='1'; ---5bit 	RXNbit=5
		 wait for 104166 ns;
			
		 Rx_in<='1'; ---6bit 	RXNbit=6
		 wait for 104166 ns;
		 
		 Rx_in<='0'; ---7bit 	RXNbit=7
		 wait for 104166 ns;
		 
		 Rx_in<='0'; ---8bit 	RXNbit=8
		 wait for 104166 ns;
		 
		 Rx_in<='1'; ---bit parada   RXNbit=8
		 wait for 104166 ns; 
		 
		
		 
		  --siguiente tasa de baudios 192000 baudios s
		 wait for 1ms;
		 
		  baud_sel<='1';
		  
		 wait for 100ns;
		 
		 
		  Rx_in<='0'; --- inicio  RXNbit=0
		 wait for 52008 ns;	
	
		 Rx_in<='0'; ---1bit 	RXNbit=1		
		 wait for 52008 ns;
		 
		 Rx_in<='1'; ---2bit 	RXNbit=2
		 wait for 52008 ns;
		 
		 Rx_in<='0'; ---3bit 	RXNbit=3
		 wait for 52008 ns;
		 
		 
		 Rx_in<='1'; ---4bit 	RXNbit=4
		 wait for 52008 ns;
		 
		 Rx_in<='1'; ---5bit 	RXNbit=5
		 wait for 52008 ns;
			
		 Rx_in<='1'; ---6bit 	RXNbit=6
		 wait for 52008 ns;
		 
		 Rx_in<='0'; ---7bit 	RXNbit=7
		 wait for 52008 ns;
		 
		 Rx_in<='0'; ---8bit 	RXNbit=8
		 wait for 52008 ns;
		 
		 Rx_in<='1'; ---bit parada   RXNbit=8
		 wait for 52008 ns; 
		 
		 -- vamos a probar el error ahora 
		 
		-- y que al rato vuelva a funcionar
		  wait for 100ns;
		 
		 
		  Rx_in<='0'; --- inicio  RXNbit=0
		 wait for 52008 ns;	
	
		 Rx_in<='0'; ---1bit 	RXNbit=1		
		 wait for 52008 ns;
		 
		 Rx_in<='1'; ---2bit 	RXNbit=2
		 wait for 52008 ns;
		 
		 Rx_in<='0'; ---3bit 	RXNbit=3
		 wait for 52008 ns;
		 
		 
		 Rx_in<='1'; ---4bit 	RXNbit=4
		 wait for 52008 ns;
		 
		 Rx_in<='1'; ---5bit 	RXNbit=5
		 wait for 52008 ns;
			
		 Rx_in<='1'; ---6bit 	RXNbit=6
		 wait for 52008 ns;
		 
		 Rx_in<='0'; ---7bit 	RXNbit=7
		 wait for 52008 ns;
		 
		 Rx_in<='0'; ---8bit 	RXNbit=8
		 wait for 52008 ns;
		 
		 Rx_in<='0'; ---bit parada   RXNbit=8
		 wait for 52008 ns; 
		 
		 
		 wait for 1ms;
		 Rx_in<='1'; ---ahora que vuelva
		 
		 
		 -- y ahora volvemos a probar el 1 caso despues del error
		  wait for 1ms;
		 baud_sel<='0';
		 wait for 20ns;
		 Rx_in<='0'; --- inicio  RXNbit=0
		 wait for 104166 ns;	
	
		 Rx_in<='1'; ---1bit 	RXNbit=1		
		 wait for 104166 ns;
		 
		 Rx_in<='1'; ---2bit 	RXNbit=2
		 wait for 104166 ns;
		 
		 Rx_in<='0'; ---3bit 	RXNbit=3
		 wait for 104166 ns;
		 
		 
		 Rx_in<='0'; ---4bit 	RXNbit=4
		 wait for 104166 ns;
		 
		 Rx_in<='1'; ---5bit 	RXNbit=5
		 wait for 104166 ns;
			
		 Rx_in<='1'; ---6bit 	RXNbit=6
		 wait for 104166 ns;
		 
		 Rx_in<='0'; ---7bit 	RXNbit=7
		 wait for 104166 ns;
		 
		 Rx_in<='0'; ---8bit 	RXNbit=8
		 wait for 104166 ns;
		 
		 Rx_in<='1'; ---bit parada   RXNbit=8
		 wait for 104166 ns; 
		 
		 
		 -- ahora vamos a probar a cambiar la velocidad de recepcion delos datos en medio de un envio y ver que pasaria 
		-- en este caso no debería cambiar hasta que estemos en espera
		
		
      -- insert stimulus here 

      wait;
   end process;

END;
