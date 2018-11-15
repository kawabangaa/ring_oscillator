library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use work.ro_package.all;
entity RO_unit is
	port(
		clk : in std_logic;
		rst : in std_logic;
		start : in std_logic;
		ref_clk : in std_logic;
		rd_en : in std_logic;
		empty : out std_logic;
		dout : out std_logic_vector(DOUT_WIDTH - 1 downto 0)
		
		
	);
end entity RO_unit;

architecture RTL of RO_unit is
	
	component fifo_generator_0 IS
  	PORT (
    rst : IN STD_LOGIC;
    wr_clk : IN STD_LOGIC;
    rd_clk : IN STD_LOGIC;
    din : IN STD_LOGIC_VECTOR(63 DOWNTO 0);
    wr_en : IN STD_LOGIC;
    rd_en : IN STD_LOGIC;
    dout : OUT STD_LOGIC_VECTOR(63 DOWNTO 0);
    full : OUT STD_LOGIC;
    empty : OUT STD_LOGIC
  	);
	END component;

		component RO is
	port(
		enable : in std_logic;
		output : out std_logic
	);
end component;

signal ro_output : std_logic;

signal start_synchronizer : std_logic_vector (2 downto 0);
signal start_synced : std_logic;
signal start_pulse_d : std_logic;
signal start_pulse : std_logic;
signal accumulator : integer range 0 to 2**ACC_WIDTH;
signal en_acc : std_logic;
signal frame_cnt : integer range 0 to FRAME_SIZE;

begin
	-- syncs the enable to the clock of the RO_unit
	process(clk, rst)
	begin
		if rst = '1' then
			start_synchronizer <= (others => '0');
			start_synced <= '0';
			
			start_pulse_d <= '0';
			start_pulse <= '0';
		elsif rising_edge(clk) then
			start_synchronizer(0) <= start;
			start_synchronizer(1) <= start_synchronizer(0);
			start_synchronizer(2) <= start_synchronizer(1);
			
			start_pulse_d <= start_synced;
			start_pulse <= start_pulse_d and not start_synced;
			
		end if;
	end process;
	start_synced <= start_synchronizer(2) xor start_synchronizer(1);
	
	-- frame counter
	process (clk, rst)
	begin
		if (rst = '1') then
			frame_cnt <= 0;
			en_acc <= '0';
		elsif rising_edge(clk) then
			en_acc <= '0';
			if start_pulse = '1' then
				frame_cnt <= 0;
			elsif frame_cnt < FRAME_SIZE then
				en_acc <= '1';
				frame_cnt <= frame_cnt + 1;
			elsif frame_cnt = 
			end if;
		end if;
	end process;
	
	-- accumulats the RO output
	process(clk,rst)
	begin
		if (rst = '1') then
			accumulator <= 0;
		elsif rising_edge(clk) then
			if en_acc = '1' then
				if ro_output = '1' then
					accumulator <= accumulator + 1;
				end if;
			end if;
		end if;
					
	end process;
		
	
	ro_inst : RO 
	port map (
		enable => en_synced,
		output => ro_output
		);
	
	

end architecture RTL;
