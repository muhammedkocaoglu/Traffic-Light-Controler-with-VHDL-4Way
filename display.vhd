library ieee;
use ieee.std_logic_1164.all;


entity display is
   port(
	   SW  :  in std_logic_vector(3 downto 0);
		HEX0 :  out std_logic_vector(6 downto 0);
		HEX1 :  out std_logic_vector(6 downto 0)
	);
end display;


architecture behaviour of display is
begin
   process(SW)
	begin
	   case SW is
		   when "0000"  =>  HEX0 <= "1000000";  --0 
			                 HEX1 <= "1000000";
         when "0001"  =>  HEX0 <= "1111001";  --1
			                 HEX1 <= "1000000";
			when "0010"  =>  HEX0 <= "0100100";  --2
			                 HEX1 <= "1000000";
			when "0011"  =>  HEX0 <= "0110000";  --3
			                 HEX1 <= "1000000";
			when "0100"  =>  HEX0 <= "0011001";  --4 
			                 HEX1 <= "1000000";
			when "0101"  =>  HEX0 <= "0010010";  --5 
			                 HEX1 <= "1000000";
			when "0110"  =>  HEX0 <= "0000010";  --6
			                 HEX1 <= "1000000";
			when "0111"  =>  HEX0 <= "1111000";  --7
			                 HEX1 <= "1000000";
			when "1000"  =>  HEX0 <= "0000000";  --8
			                 HEX1 <= "1000000";
			when "1001"  =>  HEX0 <= "0010000";  --9
			                 HEX1 <= "1000000";
			when "1010"  =>  HEX0 <= "1000000";  --10
			                 HEX1 <= "1111001";
			when "1011"  =>  HEX0 <= "1111001";  --11
			                 HEX1 <= "1111001";
			when "1100"  =>  HEX0 <= "0100100";  --12 
			                 HEX1 <= "1111001";
			when "1101"  =>  HEX0 <= "0110000";  --13 
			                 HEX1 <= "1111001";
			when "1110"  =>  HEX0 <= "0011001";  --14 
			                 HEX1 <= "1111001";
			when "1111"  =>  HEX0 <= "0010010";  --15
			                 HEX1 <= "1111001";
			when others  =>  HEX0 <= "0001000";  --A
			                 HEX1 <= "0001000";
		end case;
	end process;
	
end behaviour;