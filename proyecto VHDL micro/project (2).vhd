----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date:    17:50:21 05/14/2024 
-- Design Name: 
-- Module Name:    project - Behavioral 
-- Project Name: 
-- Target Devices: 
-- Tool versions: 
-- Description: 
--
-- Dependencies: 
--
-- Revision: 
-- Revision 0.01 - File Created
-- Additional Comments: 
--
----------------------------------------------------------------------------------
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx primitives in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity project is
    Port ( Rx_in : in  STD_LOGIC;
           baud_sel : in  STD_LOGIC;
           clk : in  STD_LOGIC;
           reset : in  STD_LOGIC;
           Rx_data : out  STD_LOGIC_VECTOR (7 downto 0);
           RX_newdata : out  STD_LOGIC;
           Rx_error : out  STD_LOGIC);
end project;

architecture Behavioral of project is
signal baudRate_counter_limit,cont: unsigned(15 downto   0);
signal enable_baudRate,enable_regRX,enableRSR,enable_Receiver_counter,enable_rxnw,enable_rxerror:std_logic;
signal s_reset:std_logic;
signal bit_sample,out_baud_rate:std_logic; --

signal RSR:std_logic_vector(7 downto 0);
signal RX_nbits:unsigned(3 downto 0);

type mis_estados is(espera,inicio,recibiendo,fin,error);

signal estado_actual,estado_siguiente:mis_estados;
begin

baudRateCounterLimit:process(baud_sel)
	begin
		if(baud_sel='0') then
			baudRate_counter_limit<="0001010001011000"; --9600 baudios   ->5208ck
		else
			baudRate_counter_limit<="0000101000101100";--19200 baudios --> 2604 ck
		end if;
	end process;
	
	
				
			
process(out_baud_rate)
	begin
		if(out_baud_rate='1') then
			bit_sample<='1';
		else
			bit_sample<='0';
		end if;
	end process;
--baudRateCounter	
process(reset,clk)
	begin
		if(reset='1') then
			cont<=(others=>'0');
			out_baud_rate<='0';
		elsif(clk'event and clk='1') then
			if(enable_baudRate='1') then
				if(s_reset='1') then
					cont<=(others=>'0');
					out_baud_rate<='0';
				elsif (cont=baudRate_counter_limit) then
					cont<=(others=>'0');
					out_baud_rate<='1';
				else
					cont<=cont +1;
					out_baud_rate<='0';
				
				end if;
			end if;
		end if;
	end process;
		
--RSR
process(clk,reset)
	begin
		if(reset='1') then
			RSR<=(others=>'0');
		elsif(clk'event and clk='1') then
			if(enableRSR='1') then
				if(s_reset='1') then
					RSR<=(others=>'0');
				elsif(bit_sample='1' and RX_nbits<8) then 
					RSR<=Rx_in &  RSR(7 downto 1) ;
				end if;
			end if;
		end if;
	end process;
--ReceiveCounter
 process(clk,reset)
	begin
		if(reset='1') then
			RX_nbits<=(others=>'0');
		elsif(clk'event and clk='1') then 
			if(s_reset='1' ) then
				RX_nbits<=(others=>'0');
			elsif(enable_Receiver_counter='1' and bit_sample='1') then
				if(RX_nbits<10) then --- bit 9 será bit de parada
					RX_nbits<=RX_nbits +1; 
				else
					RX_nbits<=(others=>'0');
				end if;
			end if;
		end if;
	end process;
				
--regRX
process(reset,clk)  
	begin
		if(reset='1') then
			RX_data<=(others=>'0');
		elsif(clk'event and clk='1') then
			if(enable_regRX='1') then
				RX_data<=RSR;
			end if;
		end if;
	end process;
--RegRX_newdata
process(reset,clk)
	begin
		if(reset='1') then
			RX_newdata<='0';
		elsif(clk'event and clk='1') then
			if(enable_rxnw='1') then 
				RX_newdata<='1';
			else
				RX_newdata<='0';
			end if;
		end if;
	end process;
--regRX_error
process(reset,clk)
	begin
		if(reset='1') then
			RX_error<='0';
		elsif(clk'event and clk='1') then
			if(enable_rxerror='1') then
				RX_error<='1';
			else 
				RX_error<='0';
			end if;
			
		end if;
	end process;
	

--FSM
process(reset,clk)
	begin
		if(reset='1') then 
			estado_actual<=espera;
		elsif(clk'event and clk='1') then
			estado_actual<= estado_siguiente;
		end if;
	end process;
process(estado_actual,Rx_in,RX_nbits)
	begin
		case estado_actual is
			when espera 		=>
										if(Rx_in='0') then
											estado_siguiente<=inicio;
										else
											estado_siguiente<=espera;
										end if;
			when inicio			=>
										estado_siguiente<=recibiendo;
								
			when recibiendo	=> 
										if(Rx_nbits<9) then  
											estado_siguiente<=recibiendo;
										elsif(Rx_in='1') then
											estado_siguiente <=fin;
										else 
											estado_siguiente<=error;
										end if;
			when error 			=> 
										if(Rx_in='1') then
											estado_siguiente<=espera;
									 	else
											estado_siguiente<=error;
										end if;
			when fin				=>
										estado_siguiente<=espera;
		end case;
	end process;

process(estado_actual)
	begin
		case estado_actual is
			when espera 		=>
										s_reset<='0';
										enable_baudRate<='0';
										enable_regRX<='0';
										enableRSR<='0';
										enable_Receiver_counter<='0';
										enable_rxnw<='0';
										enable_rxerror<='0';
										 
										
			when inicio			=>
										 s_reset<='0';
										enable_baudRate<='1';
										enable_regRX<='0';
										enableRSR<='1';
										enable_Receiver_counter<='1';
										enable_rxnw<='0';
										enable_rxerror<='0';
										 
										 
								
			when recibiendo	=> 
										s_reset<='0'; 
										enable_baudRate<='1';
										enable_regRX<='0';
										enableRSR<='1';
										enable_Receiver_counter<='1';
										enable_rxnw<='0';
										enable_rxerror<='0';
										 
			when error 			=> 
										 s_reset<='1';
										enable_baudRate<='0';
										enable_regRX<='0';
										enableRSR<='0';
										enable_Receiver_counter<='0';
										enable_rxnw<='0';
										enable_rxerror<='1';
										 
										 
			when fin				=>
									
										 s_reset<='1';
										enable_baudRate<='0';
										enable_regRX<='1';
										enableRSR<='0';
										enable_Receiver_counter<='0';
										enable_rxnw<='1';
										enable_rxerror<='0';
										 
										 
		end case;
	end process;

end Behavioral;

