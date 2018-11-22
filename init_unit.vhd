library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

use work.ro_package.all;

entity init_unit is
	port(
		clk : in std_logic;
		rst : in std_logic;
		-- ro IF
		busy_arr : in t_bit_arr;
		start : out t_bit_arr;
		-- uart IF
		s_axi_araddr          : out std_logic_vector(C_AXI_ADD_W-1 downto 0); -- read address
		s_axi_arvalid         : out std_logic; -- read address valid, should be up until ready is up
		s_axi_arready         : in  std_logic; -- read address ready
		s_axi_rdata           : in  std_logic_vector(31 downto 0); -- data read
		s_axi_rresp           : in  std_logic_vector(1 downto 0); -- read response, should outdicate errors
		s_axi_rvalid          : in  std_logic; -- data read valid, should remaout high untill ready is up
		s_axi_rready          : out std_logic; -- data read ready, when recieved the data and ready for more (should be raised after the data has been sampled, only an indicator)
		interrupt             : in  std_logic
		);
end entity init_unit;

architecture RTL of init_unit is
	-- ro sm
	type t_ro_sm is (WAIT_FOR_START, INIT, WAIT_FOR_END, DEC_CNT);
	signal ro_sm : t_ro_sm;
	signal dec_pending : std_logic;
	signal start_assignment : std_logic;
	signal start_int : t_bit_arr;
	
	-- pending cnt
	signal pending_cnt : integer range 0 to NUM_OF_PENDING_REQUEST - 1;
	signal busy : std_logic;
	
	-- read sm
	signal inc_pending : std_logic;
	type t_read_sm  is (WAIT_FOR_IRQ,WAIT_FOR_ADDR_READY, WAIT_FOR_READ_VALID,INC_CNT);
	signal read_sm : t_read_sm;
	
	-- synchronizer
	type t_busy_sync is array (3) of t_bit_arr;
	signal busy_synchronizer : t_busy_sync;
	signal busy_synced : t_bit_arr;
begin
	
	ro_sm_process : process(clk, rst)
	begin
		if rst = '1' then
			ro_sm <= WAIT_FOR_START;
			start <= (others => '0');
		elsif rising_edge(clk) then
			start <= start_int;
			case ro_sm is
			when WAIT_FOR_START =>
				if pending_cnt /= 0 then
					ro_sm <= INIT;
				end if;
			when INIT =>
				ro_sm <= WAIT_FOR_END;
			when WAIT_FOR_END =>
				if (busy = '0') then
					ro_sm <= DEC_CNT;
				end if;
			when DEC_CNT =>
				ro_sm <= WAIT_FOR_START;
			end case;
		end if;
	end process;
	-- async assignments
	dec_pending <= '1' when ro_sm = DEC_CNT else '0';
	start_assignment <= '1' when ro_sm = INIT else '0';
	
	start_process : process (start_assignment)
		variable  start_var : t_bit_arr;
	begin
	    start_loop : for k in 0 to NUM_OF_RO-1 loop
      		start_var(k) := start_assignment;
    	end loop start_loop;
    	start_int <= start_var;
	end process;
	
	busy_async_process : process (busy_synced)
		variable and_int : std_logic;
	begin
	    and_loop : for k in 0 to NUM_OF_RO-1 loop
      		and_int := and_int or busy_synced(k);
    	end loop and_loop;
    	busy <= and_int;
	end process;
	
	pending_cnt_process : process(rst, clk)
	begin
		if rst = '1' then
			pending_cnt <= 0;
		elsif rising_edge(clk) then
			if inc_pending = '1' then
				if dec_pending = '0' then
					pending_cnt <= pending_cnt + 1;
				end if;
			else
				if dec_pending = '1' then
					pending_cnt <= pending_cnt - 1;
				end if;
			end if;
			
		end if;
	end process;
	
	-- read sm
	read_sm_process : process(rst, clk)
	begin
		if rst = '1' then
			read_sm <= WAIT_FOR_IRQ;
		elsif rising_edge(clk) then
			case read_sm is
			when WAIT_FOR_IRQ =>
				if interrupt = IRQ_POL then
					read_sm <= WAIT_FOR_ADDR_READY;
				end if;
			when WAIT_FOR_ADDR_READY =>
				if s_axi_arready = '1' then
					read_sm <= WAIT_FOR_READ_VALID;
				end if;
			when WAIT_FOR_READ_VALID =>
				if s_axi_rvalid = '1' then
					if  s_axi_rdata(7 downto 0) = START_SEQUENCE then
						read_sm <= INC_CNT;
					end if;
				end if;
			when INC_CNT =>
				read_sm <= WAIT_FOR_IRQ; 
			end case;
			
		end if;
	end process;
	-- async assignment
	inc_pending <= '1' when read_sm = INC_CNT else '0';
	
	-- syncs the enable to the clock of the RO_unit
	sync_process: process(clk, rst)
		variable busy_var : t_bit_arr;
	begin
		if rst = '1' then
			busy_synchronizer <= (others => (others => '0'));
			busy_synced <= (others => '0');
			
		elsif rising_edge(clk) then
			busy_synchronizer(0) <= busy_arr;
			busy_synchronizer(1) <= busy_synchronizer(0);
			busy_synchronizer(2) <= busy_synchronizer(1);
			
		
			busy_loop : for k in 0 to NUM_OF_RO-1 loop
      			busy_var(k) :=  busy_synchronizer(2)(k) xor busy_synchronizer(1)(k);
    		end loop busy_loop;
    		busy_synced <= busy_var;
		end if;
	end process;
	
end architecture RTL;
