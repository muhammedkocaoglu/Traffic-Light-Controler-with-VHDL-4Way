library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_unsigned.all;

entity traffic is
   port(
	   CLOCK_50 	: in std_logic; --50Mhz Clock
		clr 			: in std_logic; --reset signal
		crosswalk 	: in std_logic; --button for pedestrians
		
		--Outputs:
		HEX0 			:  out std_logic_vector(6 downto 0); --seven segment display1
		HEX1 			:  out std_logic_vector(6 downto 0); --seven segment display2
		GPIO_1 		: out std_logic_vector(13 downto 0)  --external pins to be connected to leds
		);
end traffic;

architecture traffic of traffic is
----------------------------------------------------------
      component display is
		   port(
	         SW  :  in std_logic_vector(3 downto 0);
		      HEX0 :  out std_logic_vector(6 downto 0);
		      HEX1 :  out std_logic_vector(6 downto 0)
	      );
		end component;
----------------------------------------------------------

type state_type is (s0,s1,s2,s3,s4,s5,s6,s7,s8,s9);
signal state : state_type;
signal state_signal : state_type;
signal state_signal_next : state_type;
signal GPIO_1_signal : std_logic_vector(13 downto 0);
signal clk_sig : std_logic;
signal crosswalk_signal : std_logic;
signal count : std_logic_vector(3 downto 0);

constant sec10 : std_logic_vector(3 downto 0) := "0110";
constant sec2 : std_logic_vector(3 downto 0) := "0010";

begin
      
		M1 : display port map( SW=>count , HEX0=>HEX0 , HEX1=>HEX1);
		
		--generate 1Hz(1seconds= from 50MHZ clock
      process(clr,CLOCK_50)
      variable   cnt   : integer;
      begin
         if (clr='0') then
            clk_sig<='0';
            cnt:=0;
         elsif rising_edge(CLOCK_50) then
            if (cnt=24999999) then
               clk_sig<=NOT(clk_sig);  --toggle
               cnt:=0;
            else
               cnt:=cnt+1;
            end if;
        end if;
      end process;


		--state controls
      process(clk_sig,clr,crosswalk,state)
		begin
		   if clr = '0' then 
			      state <= s0;
					count <= sec10;
			
			elsif clk_sig'event and clk_sig = '1' then 
			      case state is
					   when s0 =>	
			
                     if crosswalk = '0' then
							   crosswalk_signal <= '1';
							   state <= s8;
								state_signal <= s1;
								state_signal_next <= s2;
								count <= count;
							elsif count > "0000" then
							   
					         GPIO_1_signal <= "10000110010010";
							   state <= s0;
								count <= count - 1;
								
							else 
								state <= s1;
							   count <= sec2;
							end if;
						when s1 =>
						     
						      if count > "0000" then 								 							
					               GPIO_1_signal <= "10001010010010";
								      state <= s1;
									   count <= count - 1;
									
									
								else 
								   if crosswalk_signal = '1' then							  
									   count <= "1111";
										state <= s9;
									else
								      state <= s2;
									   count <= sec10;
									end if;
								end if;
						when s2 =>
						      if crosswalk = '0' then
								   crosswalk_signal <= '1';
							      state <= s8;
									state_signal <= s3;
									state_signal_next <= s4;
									count <= count;
						      elsif count > "0000" then 
								   
					            GPIO_1_signal <= "10010000110010";
								
								   state <= s2;
									count <= count - 1;
									
								else 
								   state <= s3;
									count <= sec2;
								end if;
						when s3 =>
						      
						      if count > "0000" then 
								   
					            GPIO_1_signal <= "10010001010010";		
								   state <= s3;
									count <= count - 1;		
			                  				
								else 
								   if crosswalk_signal = '1' then
									   count <= "1111";
										state <= s9;
									else
								      state <= s4;
									   count <= sec10;
									end if;
								end if;
						when s4 =>
						      if crosswalk = '0' then
								   crosswalk_signal <= '1';
							      state <= s8;
									state_signal <= s5;
									state_signal_next <= s6;
									count <= count;
						      elsif count > "0000" then 
								   
					            GPIO_1_signal <= "10010010000110";
								   state <= s4;
									count <= count - 1;		
			                  						
								else 
								   state <= s5;
									count <= sec2;
								end if;
						when s5 =>
						      if count > "0000" then 
								   
					            GPIO_1_signal <= "10010010001010";
								   state <= s5;
									count <= count - 1;                        
								
								else 
								   if crosswalk_signal = '1' then
									   count <= "1111";
									   state <= s9;
									else
								      state <= s6;
									   count <= sec10;
									end if;
								end if;
						when s6 =>
						      if crosswalk = '0' then
								   crosswalk_signal <= '1';
							      state <= s8;
									state_signal <= s7;
									state_signal_next <= s0;
									count <= count;
						      elsif count > "0000" then 
								   GPIO_1_signal <= "00110010010010";
								   state <= s6;
									count <= count - 1;		       
									
								else 
								   state <= s7;
									count <= sec2;
								end if;
						when s7 =>
						      if count > "0000" then 
								   state <= s7;
									count <= count - 1;			               
					            GPIO_1_signal <= "01010010010010";					
								else 
								   if crosswalk_signal = '1' then
									   count <= "1111";
										state <= s9;
									else
								      state <= s0;
									   count <= sec10;
									end if;
								end if;
						when s8 =>
						      
						      if count > "0000" then 
									count <= count - 1;
									
								else
								   state <= state_signal;
									count <= sec2;
								end if;
						when s9 => 					
						      if count > "0000" then
								   count <= count - 1;
									state <= s9;
									
									GPIO_1_signal <= "10010010010001";
								else
								   state <= state_signal_next;
									count <= sec10;
									crosswalk_signal <= '0';
								end if;
						when others =>
						      state <= s0;
					end case;
				end if;
			end process;
			
			
			--external pins assignments
			process(state) 
			begin
			   case state is
				   when s0 => GPIO_1 <= "10000110010010";
					when s1 => GPIO_1 <= "10001010010010";
					when s2 => GPIO_1 <= "10010000110010";
		         when s3 => GPIO_1 <= "10010001010010";
					when s4 => GPIO_1 <= "10010010000110";
					when s5 => GPIO_1 <= "10010010001010";
					when s6 => GPIO_1 <= "00110010010010";
					when s7 => GPIO_1 <= "01010010010010";
					when s8 => GPIO_1 <= GPIO_1_signal;
					when s9 => GPIO_1 <= "10010010010001";
					when others => GPIO_1 <= "00000000000000";
				        
				end case;
			end process;

end traffic;