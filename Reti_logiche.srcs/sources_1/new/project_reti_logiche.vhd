library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;
use IEEE.STD_LOGIC_ARITH.ALL;
use ieee.std_logic_unsigned.all;

entity project_reti_logiche is
    Port ( i_clk : in STD_LOGIC;
           i_rst : in STD_LOGIC;
           i_start : in STD_LOGIC;
           i_data : in std_logic_vector(7 downto 0);
           o_address : out std_logic_vector(15 downto 0);
           o_done : out STD_LOGIC;
           o_en : out STD_LOGIC;
           o_we : out STD_LOGIC;
           o_data : out std_logic_vector(7 downto 0)
           );
end project_reti_logiche;

architecture Behavioral of project_reti_logiche is
    type state_type is (START, INIT, GET_DIM,GET_RC, ABILITY_MEMRW,WAIT_MEM, DISABILITY_MEMRW, READ_PIXEL, GET_MINMAX, GET_DELTA); --, NEW_PIXEL, DONE
    signal next_state,curr_state, prev_state: state_type;

    --signal to store
    signal n_col: std_logic_vector(7 downto 0):= (others => '0');
    signal n_row: std_logic_vector(7 downto 0):= (others => '0');
    signal max_pixel_value: std_logic_vector(7 downto 0):= (others => '0');
    signal min_pixel_value: std_logic_vector(7 downto 0):= (others => '1');
    signal delta_value: std_logic_vector (7 downto 0):= (others => '0');
   -- signal shift_level: integer range 0 to 8:= 0;
    --signal new_pixel_value: integer range 0 to 255:=0;
    --signal temp_pixel: integer range 0 to 255 := 0;
    signal curr_address: std_logic_vector(15 downto 0) :="0000000000000000";
    signal dim_address: std_logic_vector(15 downto 0) :="0000000000000000";

    --signal to work with
    signal n_col_cp: std_logic_vector(7 downto 0):= (others => '0');
    signal n_row_cp: std_logic_vector(7 downto 0):= (others => '0');
    signal max_pixel_value_cp: std_logic_vector(7 downto 0):= (others => '0');
    signal min_pixel_value_cp: std_logic_vector(7 downto 0):= (others => '1');
    signal delta_value_cp: std_logic_vector(7 downto 0):= (others => '0');
   -- signal shift_level_cp: integer range 0 to 8:= 0;
    --signal new_pixel_value_cp: integer range 0 to 255:=0;
    --signal temp_pixel_cp: integer range 0 to 255 := 0;
    signal curr_address_cp: std_logic_vector(15 downto 0) :="0000000000000000";
    signal dim_address_cp: std_logic_vector(15 downto 0) :="0000000000000000";

    --signal to update output
    signal o_address_next: std_logic_vector(15 downto 0) :="0000000000000000";
    signal o_done_next: std_logic :='0';
    signal o_en_next: std_logic  :='0';
    signal o_we_next: std_logic :='0';
    signal o_data_next: std_logic_vector(7 downto 0) :="00000000";

begin
  process(i_clk,i_rst)
    begin
      if(i_rst='1') then
        n_col<=(others => '0');
        n_row<=(others => '0');
        max_pixel_value<=(others => '0');
        min_pixel_value<= (others => '1');
        delta_value<=(others => '0');
      --  shift_level<=0;
      --  new_pixel_value<=0;
       -- temp_pixel<=0;
        dim_address<=(others => '0');

        curr_state<=START;

      elsif(rising_edge(i_clk)) then
        o_done <= o_done_next;
        o_en <= o_en_next;
        o_we <= o_we_next;
        o_data <= o_data_next;
        o_address <= o_address_next;

        n_col<=n_col_cp;
        n_row<=n_row_cp;
        max_pixel_value<=max_pixel_value_cp;
        min_pixel_value<=min_pixel_value_cp;
        delta_value<=delta_value_cp;
       -- shift_level<=shift_level_cp;
       -- new_pixel_value<=new_pixel_value_cp;
       -- temp_pixel<=temp_pixel_cp;
        curr_address<=curr_address_cp;
        dim_address<=dim_address_cp;
        prev_state<=curr_state;
        curr_state<=next_state;
      end if;
  end process;

  process(curr_address, n_col, n_row, curr_state, i_start, i_data, dim_address) -- delta_value,shift_level, new_pixel_value, temp_pixel,max_pixel_value, min_pixel_value
    variable dim: std_logic_vector(15 downto 0);
  begin
     o_done_next <= '0';
     o_data_next <= "00000000";
     o_address_next <= "0000000000000000";

     max_pixel_value_cp<= max_pixel_value;
     min_pixel_value_cp<=min_pixel_value;
     delta_value_cp<=delta_value;
     --shift_level_cp<=shift_level;
     --new_pixel_value_cp<=new_pixel_value;
     --temp_pixel_cp<=temp_pixel;
     curr_address_cp<=curr_address;
     dim_address_cp<=dim_address;

     case curr_state is
        when START =>
            if(i_start='1') then
                next_state<=INIT;
            end if;

        when INIT =>
            n_col_cp<=(others => '0');
            n_row_cp<=(others => '0');
            o_en_next <= '0';
            o_we_next <= '0';
            max_pixel_value_cp<=(others =>'0');
            min_pixel_value_cp<=(others=> '1');
            delta_value_cp<=(others=> '0');
           -- shift_level<=0;
           -- new_pixel_value<=0;
           -- temp_pixel<=0;
            curr_address_cp<=(others => '0');
            dim_address_cp<=(others => '0');
            next_state<= ABILITY_MEMRW;

        when ABILITY_MEMRW =>
          case prev_state is
              when INIT =>
                  next_state<=GET_RC;
                  o_en_next<='1';
                  o_we_next<='0';
              when GET_DIM  =>
                  next_state<=READ_PIXEL;
                  o_en_next<='1';
                  o_we_next<='0';
              when others =>
                  next_state<=START;
                  o_en_next<='0';
                  o_we_next<='0';
          end case;

        when WAIT_MEM=>
            if (prev_state=GET_RC) then
                next_state<=GET_RC;
            elsif (prev_state=GET_DIM) then
                next_state<=GET_DIM;
            elsif (prev_state<=READ_PIXEL) then
                next_state<=GET_MINMAX;
            end if;

        when GET_RC =>
            if (curr_address="0000000000000000") then
                o_address_next<= curr_address;
                curr_address_cp<= curr_address+1;
                next_state<=WAIT_MEM;
            elsif (curr_address="0000000000000001") then
               n_col_cp<=i_data;
               o_address_next<= curr_address;
               curr_address_cp<= curr_address+1;
               next_state<=WAIT_MEM;
            else
               n_row_cp<=i_data;
               next_state<=GET_DIM;
            end if;

        when GET_DIM=>
            dim:= (n_col)*(n_row)+2;
            dim_address_cp<=dim;
            next_state<=ABILITY_MEMRW;

        when READ_PIXEL =>
            if (curr_address/=dim_address) then
                o_address_next<=curr_address;
                curr_address_cp<=curr_address+1;
                next_state<=WAIT_MEM;
            else
                next_state<=GET_DELTA;
            end if;

         when GET_MINMAX =>
            if (i_data> max_pixel_value) then
                max_pixel_value_cp<=i_data;
            end if;
            if (i_data< min_pixel_value) then
                min_pixel_value_cp<=i_data;
            end if;
            next_state<=READ_PIXEL;

         when GET_DELTA =>
            delta_value_cp<= max_pixel_value-min_pixel_value;
            --next_state<=ABILITY_MEM
            next_state<=DISABILITY_MEMRW;

         when DISABILITY_MEMRW=>
            o_en_next<='0';
            o_we_next<='0';
            o_done_next<='1';














      end case;
  end process;


end Behavioral;
