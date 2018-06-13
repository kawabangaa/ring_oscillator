library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_unsigned.all;
use ieee.numeric_std.all;


use work.ro_package.all;
entity RO_network is
	generic (
		RST_POL : std_logic
	);
	port(
		clk : in std_logic;
		rst : in std_logic;
		
		byte_in : in std_logic_vector(BYTE - 1 downto 0);
		valid_in : in std_logic;
		byte_out : in std_logic_vector(BYTE - 1 downto 0);
		valid_out : in std_logic;
		
		led_out : out std_logic_vector(C_NUM_OF_LEDS - 1 downto 0)
		
	);
end entity RO_network;

architecture RTL of RO_network is
	type t_main_state is (INIT, WAIT_FOR_SELECT, RUN_RO,SEND_RESULT,ERROR);
	signal main_sm : t_main_state;
	
	signal ro_sel : std_logic_vector(C_NUM_OF_RO-1 downto 0);
	signal ro_en_source : std_logic;
	signal ro_en : std_logic_vector(C_NUM_OF_RO - 1 downto 0);

	signal ro_output : std_logic_vector(C_NUM_OF_RO - 1 downto 0);
	signal selected_ro_out : std_logic;
	
	signal sample_counter : std_logic_vector(integer(log2(natural(SAMPLE_RESULOTION))) downto 0);
	signal sample_enable : std_logic; -- initializes the sample_counter
	
	signal cycle_counter : std_logic_vector(integer(log2(natural(MEASUREMENT_CYCLES))) downto 0);
	signal cycle_enable : std_logic;
	
	signal accepting_data : std_logic; -- enabling the byte_in_samp register
	signal byte_in_samp : std_logic_vector(BYTE - 1 downto 0);
	
	signal send_result_done : std_logic;
	component RO is
	port(
		enable : in std_logic;
		output : out std_logic
	);
	end component;
begin
	-- MAIN SM PROCESS
	process (clk,rst)
	begin
		if rst = RST_POL then
			main_sm <= INIT;
		elsif rising_edge(clk) then
			case main_sm is
			when INIT =>
				if (valid_in = '1') then
					if (byte_in = INIT_SEQUENCE) then
						main_sm <= WAIT_FOR_SELECT;
					else
						main_sm <= ERROR;
					end if;
				end if;
			when WAIT_FOR_SELECT =>
				if (valid_in = '1') then
					main_sm <= RUN_RO;
				end if;
			when RUN_RO =>
				if (integer(cycle_counter) = MEASUREMENT_CYCLES) then
					main_sm <= SEND_RESULT;
				end if;
			when SEND_RESULT =>
				if (send_result_done = '1') then
					main_sm <= INIT;
				end if;
			when ERROR =>
				main_sm <= ERROR;
			when OTHERS =>
				main_sm <= ERROR;
			end case;
		end if;
	end process ;
	
	--DMUX
	selected_ro_out <= ro_output(integer(ro_sel));
	-- MUX
	process (ro_sel, ro_en_source)
	begin
		for i in 0 to C_NUM_OF_RO - 1 loop
		if (integer(ro_sel) = i) then
			ro_en(i) <= ro_en_source;
		else 
			ro_en(i) <= '0';
		end if;
		end loop;
	end process;
	-- RO GENERATION
	ro_generation : for i in 0 to C_NUM_OF_RO-1 generate
		ro_inst : RO
		port map (
				enable => ro_en(i),
				output => ro_output(i)
			);
	end generate ro_generation;
	
	-- sample counter, cycle counter
	process (clk,rst)
		begin
		if rst = RST_POL then
			sample_counter <= (others => '0');
		elsif rising_edge(clk) then
			if (sample_enable = '1') then
				if (selected_ro_out = '1') then   	
					sample_counter <= sample_counter + 1;
				end if;
		end if;
	end process;
end architecture RTL;
