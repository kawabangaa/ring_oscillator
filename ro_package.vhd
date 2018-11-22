library ieee;
use ieee.std_logic_1164.all;

package ro_package is
    function log2(i : in natural) return integer;
	--RO file
	constant C_NUM_OF_INVERTERS : integer := 121;
	
	--RO network
	constant C_NUM_OF_RO : integer := 10;
	constant C_NUM_OF_LEDS : integer := 4;
	
	constant SAMPLE_RESULOTION : integer := 2**18; -- the width of the counter that samples the RO, must be multiplication of BYTE and power of 2
	constant MEASUREMENT_CYCLES : integer := 500 ; -- number of cycles the selected RO will be sampled.
	constant INIT_SEQUENCE : std_logic_vector(BYTE-1 downto 0) := X"AB";
	constant SAMPLE_COUNTER_WIDTH : integer ;
	constant MEASUREMENT_COUNTER_WIDTH : integer;
	constant SHIFT_CNT_MAX : integer;
	
	-- Top
	constant NUM_OF_RO : integer := 5; --number of ro's that will be implemented
	constant C_AXI_ADD_W : integer := 4;
	constant UART_WIDTH : integer := 8;
	
	-- RO unit
	constant FRAME_SIZE : integer := 500; -- frame which the sampler will work 
	constant NUM_OF_FRAMES : integer := 1023; -- depends on the depth of the fifo
	constant DOUT_WIDTH : integer := 32; -- the width of the fifo out 
	constant ACC_WIDTH : integer := 64 ; -- number of bits for the accumulator
	
	
	-- Sending Unit
	type t_read_en_arr is array (NUM_OF_RO) of std_logic;
	type t_data_arr is array (NUM_OF_RO) of std_logic_vector (DOUT_WIDTH - 1 downto 0);
	type t_empty_en_arr is array (NUM_OF_RO) of std_logic; 
	constant TX_FIFO					:	 std_logic_vector(C_AXI_ADD_W-1 downto 0):= X"4";
	
	-- init unit
	type t_bit_arr is array (NUM_OF_RO) of std_logic;
	constant NUM_OF_PENDING_REQUEST : integer := 100;
	constant IRQ_POL : std_logic := '1';
	constant START_SEQUENCE : std_logic_vector (UART_WIDTH - 1 downto 0) := X"E3";
	
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
