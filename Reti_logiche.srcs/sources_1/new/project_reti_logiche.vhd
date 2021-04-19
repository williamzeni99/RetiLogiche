----------------------------------------------------------------------------------
-- Company:
-- Engineer:
--
-- Create Date: 03/29/2021 10:52:26 AM
-- Design Name:
-- Module Name: project_reti_logiche - Behavioral
-- Project Name:
-- Target Devices:
-- Tool Versions:
-- Description:
--
-- Dependencies:
--
-- Revision:
-- Revision 0.01 - File Created
-- Additional Comments:
--
----------------------------------------------------------------------------------


library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;
use ieee.std_logic_unsigned.all;

-- Uncomment the following library declaration if instantiating
-- any Xilinx leaf cells in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

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
    type state_type is (START, INIT, GET_DIM, GET_MINDELTA, NEW_PIXEL, DONE, MEMRW);
    signal next_state,curr_state, prev_state: state_type;

    --signal to store
    signal max_pixel_value: integer range 0 to 255 := 0;
    signal min_pixel_value: integer range 0 to 255 := 255;
    signal delta_value: integer range 0 to 255 := 0;
    signal shift_level: integer range 0 to 8:= 0;
    signal new_pixel_value: integer range 0 to 255:=0;
    signal temp_pixel: integer range 0 to 255 := 0;
    signal curr_address: std_logic_vector(15 downto 0);
    signal dim_address: std_logic_vector(15 downto 0);

    --signal to work with
    signal max_pixel_value_cp: integer range 0 to 255 := 0;
    signal min_pixel_value_cp: integer range 0 to 255 := 255;
    signal delta_value_cp: integer range 0 to 255 := 0;
    signal shift_level_cp: integer range 0 to 8:= 0;
    signal new_pixel_value_cp: integer range 0 to 255:=0;
    signal temp_pixel_cp: integer range 0 to 255 := 0;
    signal curr_address_cp: std_logic_vector(15 downto 0);
    signal dim_address_cp: std_logic_vector(15 downto 0);

    --signal to update output
    signal o_address_next: std_logic_vector(15 downto 0);
    signal o_done_next: std_logic;
    signal o_en_next: std_logic;
    signal o_we_next: std_logic;
    signal o_data_next: std_logic_vector(7 downto 0);

begin
  process(i_clk,i_rst)
    begin
      if(i_rst='1') then
        max_pixel_value<=0;
        min_pixel_value<=0;
        delta_value<=0;
        shift_level<=0;
        new_pixel_value<=0;
        temp_pixel<=0;
        curr_address<=(others => '0');
        dim_address<=(others => '0');
        curr_state<=START;
        
      elsif(rising_edge(i_clk)) then
        o_done <= o_done_next;
        o_en <= o_en_next;
        o_we <= o_we_next;
        o_data <= o_data_next;
        o_address <= o_address_next;

        max_pixel_value<=max_pixel_value_cp;
        min_pixel_value<=min_pixel_value_cp;
        delta_value<=delta_value_cp;
        shift_level<=shift_level_cp;
        new_pixel_value<=new_pixel_value_cp;
        temp_pixel<=temp_pixel_cp;
        curr_address<=curr_address_cp;
        dim_address<=dim_address_cp;

        curr_state<=next_state;


      end if;
  end process;

end Behavioral;
