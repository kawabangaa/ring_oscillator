library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use work.ro_package.all;
entity sending_unit is
	port(
		clk : in std_logic;
		rst : in std_logic;
		empty_arr : in t_empty_en_arr;
		data_arr : in t_data_arr;
		read_arr : out t_read_en_arr;
		
		s_axi_awaddr          : out std_logic_vector(C_AXI_ADD_W-1 downto 0); -- write address
		s_axi_awvalid         : out std_logic; -- address valid
		s_axi_awready         : in  std_logic; -- ready to write address
		s_axi_wdata           : out std_logic_vector(31 downto 0); -- data to write
		s_axi_wstrb           : out std_logic_vector(3 downto 0); -- write strobe, to which part of the data we will be writoutg. should be constant F (writoutg allways 32 bit)
		s_axi_wvalid          : out std_logic; -- write valid, should be high until ready is up
		s_axi_wready          : in  std_logic; -- ready to receive data
		s_axi_bresp           : in  std_logic_vector(1 downto 0); -- Write response. This signal outdicates the status of the write transaction
		s_axi_bvalid          : in  std_logic; -- Write response valid. This signal outdicates that the channel is signaloutg a valid write response
		s_axi_bready          : out std_logic -- This signal outdicates that the master can accept a write response
	);
end entity sending_unit;

architecture RTL of sending_unit is
	signal idx : integer range 0 to NUM_OF_RO;
	-- read_sm signals
	type t_r_sm is (WAIT_FOR_FIFO, READ_FIFO, SEND_DATA, PREPARE);
	signal read_sm : t_r_sm;
	signal send_withdraw : std_logic;
	signal frame_cnt : integer range 0 to NUM_OF_FRAMES;
	
	-- sender_sm
	signal send_done : std_logic;
	constant NUM_OF_SHIFTS : integer := DOUT_WIDTH / UART_WIDTH;
	signal shift_idx : integer range 0 to NUM_OF_SHIFTS;
	type t_s_sm is (IDLE,SEND,DONE);
	signal send_sm : t_s_sm;
begin

read_sm_process : process (clk, rst)
begin
	if rst = '1' then
		idx <= 0;
		read_sm <= WAIT_FOR_FIFO;
	elsif rising_edge(clk) then
		case read_sm is
		when WAIT_FOR_FIFO =>
			if empty_arr(idx) = '0' then
				read_sm <= READ_FIFO;
			end if;
		when READ_FIFO =>
			if empty_arr(idx) = '1' then
				read_sm <= WAIT_FOR_FIFO;
			else
				read_arr(idx) <= '1';
				read_sm <= SEND_DATA;
			end if; 
		when SEND_DATA =>
			if send_done = '1' then
				read_sm <= PREPARE;
			end if;
		when PREPARE =>
			if frame_cnt < NUM_OF_FRAMES then
				frame_cnt <= frame_cnt + 1;
			else
				idx <= idx + 1;
				frame_cnt <= 0;
			end if;
			read_sm <= WAIT_FOR_FIFO;
		end case;
		
		
	end if;
end process;
send_withdraw <= '0' when read_sm = SEND_DATA else '1';

send_data_process : process (clk,rst)
begin
	if rst = '1' then
		send_sm <= IDLE;
		shift_idx <= 0;
	elsif rising_edge(clk) then
		
		case send_sm is
		when IDLE =>
			null;
		when SEND =>
			if shift_idx < NUM_OF_SHIFTS then
				if s_axi_wready = '1' and s_axi_bresp = "00" and s_axi_awready = '1' then
					shift_idx <= shift_idx + 1;
				end if;
			else
				shift_idx <= 0;
				send_sm <= DONE;
			end if;
		when DONE =>
			send_sm <= IDLE;
		end case;
		if send_withdraw = '1' then
			send_sm <= IDLE;
		end if;
			
	end if;
end process;
-- asynchronous assignments
send_done <= '1' when send_sm = DONE else '0';
s_axi_awvalid <= '1' when send_sm = SEND else '0';
s_axi_wvalid <= '1' when send_sm = SEND else '0';
s_axi_wstrb <= (others => '1');
s_axi_bready <= '1';

s_axi_wdata  <= X"000000"& "00" & data_arr(idx)(UART_WIDTH*(shift_idx + 1)-1 downto UART_WIDTH*shift_idx) when send_withdraw = '0' else (others => '0');
s_axi_awaddr <= TX_FIFO when send_withdraw = '0' else (others => '0');
end architecture RTL;
