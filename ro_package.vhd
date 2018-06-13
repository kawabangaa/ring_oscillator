library ieee;
use ieee.std_logic_1164.all;

package ro_package is
    function log2(i : in natural) return integer;
	--RO file
	constant C_NUM_OF_INVERTERS : integer := 121;
	
	--RO network
	constant C_NUM_OF_RO : integer := 10;
	constant C_NUM_OF_LEDS : integer := 4;
	constant BYTE : integer := 8;
	constant SAMPLE_RESULOTION : integer := 2**18; -- the width of the counter that samples the RO, must be multiplication of BYTE and power of 2
	constant MEASUREMENT_CYCLES : integer := 500 ; -- number of cycles the selected RO will be sampled.
	constant INIT_SEQUENCE : std_logic_vector(BYTE-1 downto 0) := X"AB";
	constant SAMPLE_COUNTER_WIDTH : integer ;
	constant MEASUREMENT_COUNTER_WIDTH : integer;
	constant SHIFT_CNT_MAX : integer;
	
end package ro_package;

package body ro_package is
    function log2( i : natural) return integer is
    variable temp    : integer := i;
    variable ret_val : integer := 0; 
  begin					
    while temp > 1 loop
      ret_val := ret_val + 1;
      temp    := temp / 2;     
    end loop;
  	
    return ret_val;
  end function;
	
	constant SAMPLE_COUNTER_WIDTH : integer := integer(log2(natural(SAMPLE_RESULOTION)));
	constant MEASUREMENT_COUNTER_WIDTH : integer := integer(log2(natural(MEASUREMENT_CYCLES)));
	constant SHIFT_CNT_MAX : integer := SAMPLE_COUNTER_WIDTH / BYTE;
	
end package body ro_package;
