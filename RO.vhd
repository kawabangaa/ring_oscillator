library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

use work.ro_package.all;

Library UNISIM;
use UNISIM.vcomponents.all;

entity RO is
	port(
		enable : in std_logic;
		output : out std_logic
	);
end entity  ;

architecture RTL of RO  is
	signal ro_internal : std_logic_vector(C_NUM_OF_INVERTERS-1 downto 0);
begin
RO_gen: for I in 0 to C_NUM_OF_INVERTERS-1 generate
   

first_ro : if I=0 generate
		-- LUT2: 2-input Look-Up Table with general output
		--7 Series
		-- Xilinx HDL Libraries Guide, version 14.7
		LUT2_inst : LUT2
		generic map (
		INIT => "1000")
		port map (
		O => ro_internal(I+1),
		-- LUT general output
		I0 => ro_internal(I), -- LUT input
		I1 => enable -- LUT input
		);
		-- End of LUT2_inst instantiation
	
    	
	end generate first_ro;
   	middle_ro: if I>0 and I<(C_NUM_OF_INVERTERS-1) generate
		-- LUT1: 1-input Look-Up Table with general output
		--7 Series
		-- Xilinx HDL Libraries Guide, version 14.7
		middle_LUT1 : LUT1
		generic map (
		INIT => "10")
		port map (
		O => ro_internal(I+1),
		-- LUT general output
		I0 => ro_internal(I) -- LUT input
		);
		-- End of LUT1_inst instantiation
	end generate middle_ro;	
	last_ro : if I = (C_NUM_OF_INVERTERS-1) generate
				-- LUT1: 1-input Look-Up Table with general output
		--7 Series
		-- Xilinx HDL Libraries Guide, version 14.7
		middle_LUT1 : LUT1
		generic map (
		INIT => "10")
		port map (
		O => ro_internal(0),
		-- LUT general output
		I0 => ro_internal(I) -- LUT input
		);
		-- End of LUT1_inst instantiation
	end generate last_ro;	
end generate RO_gen;
output <= ro_internal(0);
		

end architecture RTL;
