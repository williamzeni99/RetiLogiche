library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;
use ieee.std_logic_unsigned.all;

entity project_reti_logiche is
    Port ( i_clk :      in STD_LOGIC;
           i_rst :      in STD_LOGIC;
           i_start :    in STD_LOGIC;
           i_data :     in std_logic_vector(7 downto 0);
           o_address :  out std_logic_vector(15 downto 0);
           o_done :     out STD_LOGIC;
           o_en :       out STD_LOGIC;
           o_we :       out STD_LOGIC;
           o_data :     out std_logic_vector(7 downto 0)
           );
end project_reti_logiche;

architecture Behavioral of project_reti_logiche is
    type state_type is (START, INIT, GET_DIM, GET_RC,
                        ABILIT_READ, ABILIT_WRITE, WAIT_MEM,
                        DONE, READ_PIXEL, GET_MINMAX, GET_DELTA,
                        CALC_SHIFT,WRITE_PIXEL,CALC_NEWPIXEL,
                        GET_PIXEL, WAITINGPIC);
    signal next_state,curr_state, prev_state: state_type;

    --signal to store
    signal max_pixel_value:   std_logic_vector(7 downto 0)  := (others => '0');
    signal min_pixel_value:   std_logic_vector(7 downto 0)  := (others => '1');
    signal delta_value:       std_logic_vector (7 downto 0) := (others => '0');
    signal new_pixel:         std_logic_vector(7 downto 0)  := (others => '0');
    signal curr_address:      std_logic_vector(15 downto 0) := (others => '0');
    signal write_address:     std_logic_vector(15 downto 0) := (others => '0');
    signal dim_address:       integer                       := 0;
    signal shift_level:       integer                       := 0;
    signal n_col:             integer                       := 0;
    signal n_row:             integer                       := 0;
    signal m,k,t,i:           integer                       := 0;

    --signal to work with
    signal max_pixel_value_cp:      std_logic_vector(7 downto 0)  := (others => '0');
    signal min_pixel_value_cp:      std_logic_vector(7 downto 0)  := (others => '1');
    signal delta_value_cp:          std_logic_vector(7 downto 0)  := (others => '0');
    signal new_pixel_cp:            std_logic_vector(7 downto 0)  := (others => '0');
    signal curr_address_cp:         std_logic_vector(15 downto 0) := (others => '0');
    signal write_address_cp:        std_logic_vector(15 downto 0) := (others => '0');
    signal dim_address_cp:          integer                       := 0;
    signal n_col_cp:                integer                       := 0;
    signal n_row_cp:                integer                       := 0;
    signal shift_level_cp:          integer                       := 0;
    signal m_cp, k_cp, t_cp, i_cp : integer                       := 0;

    --signal to update output
    signal o_address_next:  std_logic_vector(15 downto 0) := (others => '0');
    signal o_done_next:     std_logic                     := '0';
    signal o_en_next:       std_logic                     := '0';
    signal o_we_next:       std_logic                     := '0';
    signal o_data_next:     std_logic_vector(7 downto 0)  := (others => '0');

begin
  process(i_clk,i_rst)
    begin
      if (i_rst='1') then
        max_pixel_value   <= (others => '0');
        min_pixel_value   <= (others => '1');
        delta_value       <= (others => '0');
        new_pixel         <= (others => '0');
        write_address     <= (others => '0');
        curr_state        <= START;
        dim_address       <= 0;
        n_col             <= 0;
        n_row             <= 0;
        shift_level       <= 0;
        m                 <= 0;
        k                 <= 0;
        t                 <= 0;
        i                 <= 0;

      elsif (rising_edge(i_clk)) then
        o_done    <= o_done_next;
        o_en      <= o_en_next;
        o_we      <= o_we_next;
        o_data    <= o_data_next;
        o_address <= o_address_next;

        n_col             <= n_col_cp;
        n_row             <= n_row_cp;
        max_pixel_value   <= max_pixel_value_cp;
        min_pixel_value   <= min_pixel_value_cp;
        delta_value       <= delta_value_cp;
        shift_level       <= shift_level_cp;
        new_pixel         <= new_pixel_cp;
        curr_address      <= curr_address_cp;
        write_address     <= write_address_cp;
        dim_address       <= dim_address_cp;
        m                 <= m_cp;
        k                 <= k_cp;
        t                 <= t_cp;
        i                 <= i_cp;
        prev_state        <= curr_state;
        curr_state        <= next_state;
      end if;
  end process;

  process(curr_address,i_start, i_data, n_col, n_row,
          curr_state,prev_state, dim_address, shift_level,
          new_pixel, max_pixel_value, min_pixel_value,
          delta_value, shift_level, write_address,
          m, k, t, i)

    variable pixel_to_shift: std_logic_vector(15 downto 0);
    variable last:           integer;

    begin
     n_col_cp             <= n_col;
     n_row_cp             <= n_row;
     max_pixel_value_cp   <= max_pixel_value;
     min_pixel_value_cp   <= min_pixel_value;
     delta_value_cp       <= delta_value;
     shift_level_cp       <= shift_level;
     new_pixel_cp         <= new_pixel;
     curr_address_cp      <= curr_address;
     write_address_cp     <= write_address;
     dim_address_cp       <= dim_address;

     m_cp <=  m;
     k_cp <=  k;
     t_cp <=  t;
     i_cp <=  i;

     case curr_state is
        when START =>
            if (i_start = '1') then
              next_state <= INIT;
            end if;

        when INIT =>
            max_pixel_value_cp  <=  (others =>'0');
            min_pixel_value_cp  <=  (others=> '1');
            delta_value_cp      <=  (others=> '0');
            new_pixel_cp        <=  (others => '0');
            curr_address_cp     <=  (others => '0');
            write_address_cp    <=  (others => '0');
            n_col_cp            <=  0;
            n_row_cp            <=  0;
            shift_level_cp      <=  0;
            dim_address_cp      <=  0;

            m_cp  <=  0;
            k_cp  <=  0;
            t_cp  <=  0;
            i_cp  <=  0;

            next_state <= ABILIT_READ;

        when ABILIT_READ =>
            o_en_next  <= '1';
            o_we_next  <= '0';
            if (prev_state = INIT) then
               next_state <= GET_RC;
            elsif (prev_state =GET_DIM) then
                next_state <=READ_PIXEL;
            else
                next_state <= GET_PIXEL;
            end if;

        when ABILIT_WRITE =>
            o_en_next<='1';
            o_we_next<='1';
            next_state<=WRITE_PIXEL;

        when WAIT_MEM =>
            case prev_state is
                when GET_RC =>
                    if (curr_address = "0000000000000011" ) then
                        curr_address_cp <= "0000000000000010" ;
                        next_state <= GET_DIM;
                    else
                        next_state <= GET_RC;
                    end if;

                when GET_DELTA =>
                    next_state <= CALC_SHIFT;

                when CALC_SHIFT =>
                    next_state <= CALC_SHIFT;

                when READ_PIXEL =>
                    next_state <= GET_MINMAX;

                when GET_PIXEL =>
                    next_state <= CALC_NEWPIXEL;

                when WRITE_PIXEL =>
                    next_state <= DONE;

                when others =>
                    next_state <= WAIT_MEM;

            end case;

        when GET_RC =>
            if (curr_address = "0000000000000000") then
               o_address_next  <= curr_address;
               curr_address_cp <= curr_address+1;
               next_state      <= WAIT_MEM;
            elsif (curr_address = "0000000000000001") then
               n_col_cp         <= conv_integer(i_data);
               o_address_next   <= curr_address;
               curr_address_cp  <= curr_address+1;
               next_state       <= WAIT_MEM;
            else
               n_row_cp         <= conv_integer(i_data);
               curr_address_cp  <= curr_address+1;
               next_state       <= WAIT_MEM;
            end if;

        when GET_DIM =>
            if (n_row = 0 or n_col = 0) then
                next_state <= DONE;
            else
                dim_address_cp  <= n_col*n_row+2;
                next_state      <= ABILIT_READ;
            end if;

        when READ_PIXEL =>
            if (unsigned(curr_address) /= dim_address) then
                o_address_next  <= curr_address;
                curr_address_cp <= curr_address+1;
                next_state      <= WAIT_MEM;
            else
                write_address_cp <= curr_address;
                curr_address_cp  <= "0000000000000010";
                next_state       <= GET_DELTA;
            end if;

        when GET_MINMAX =>
            if (i_data > max_pixel_value) then
                max_pixel_value_cp  <= i_data;
            end if;
            if (i_data < min_pixel_value) then
                min_pixel_value_cp  <= i_data;
            end if;
            next_state <= READ_PIXEL;

         when GET_DELTA =>
            delta_value_cp  <= max_pixel_value-min_pixel_value;
            next_state      <= WAIT_MEM;

         when CALC_SHIFT =>
            if (i=0) then
                m_cp        <= 1+ conv_integer(delta_value);
                k_cp        <= -1;
                t_cp        <= 1;
                i_cp        <= i+1;
                next_state  <= WAIT_MEM;
            elsif (t <= m and i/=0) then
                k_cp       <= k+1;
                t_cp       <= t*2;
                next_state <= WAIT_MEM;
            else
                shift_level_cp  <= 8-k;
                next_state      <= GET_PIXEL;
            end if;

         when GET_PIXEL =>
            o_address_next  <= curr_address;
            m_cp            <= 0;
            i_cp            <= 0;
            next_state      <= WAIT_MEM;

         when CALC_NEWPIXEL =>
            pixel_to_shift:= "00000000" & (i_data-min_pixel_value);
            pixel_to_shift:= std_logic_vector(shift_left(unsigned(pixel_to_shift),shift_level));
            if (conv_integer(pixel_to_shift)>=255) then
                new_pixel_cp <= "11111111";
            else
                new_pixel_cp <= pixel_to_shift(7 downto 0);
            end if;
            next_state <= ABILIT_WRITE;

         when WRITE_PIXEL =>
            o_address_next   <= write_address;
            o_data_next      <= new_pixel;
            dim_address_cp   <= dim_address+1;
            write_address_cp <= write_address+1;
            curr_address_cp  <= curr_address+1;
            last             := 2*(n_col*n_row)+2;
            if (dim_address+1 = last) then
                next_state <= WAIT_MEM;
            else
                next_state <= ABILIT_READ;
            end if;

         when DONE =>
            o_en_next       <= '0';
            o_we_next       <= '0';
            o_data_next     <= (others =>'0');
            o_address_next  <= (others =>'0');
            o_done_next     <= '1';
            next_state      <= WAITINGPIC;

         when WAITINGPIC=>
            if(i_start = '0') then
                o_done_next <= '0';
                next_state  <= START;
            else
                next_state <= WAITINGPIC;
            end if;

    end case;
  end process;
end Behavioral;
