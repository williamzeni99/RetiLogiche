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
    signal next_state, prev_state: state_type;

    signal max_pixel_value: integer range 0 to 255 := 0;
    signal min_pixel_value: integer range 0 to 255 := 255;
    signal delta_value: integer range 0 to 255 := 0;
    signal shift_level: integer range 0 to 8:= 0;
    signal new_pixel_value: integer range 0 to 255:=0;
    signal temp_pixel: integer range 0 to 255 := 0;
    signal curr_address: std_logic_vector(15 downto 0);
    signal dim_address: std_logic_vector(15 downto 0);
    signal o_address_next: std_logic_vector(15 downto 0);
    signal o_done_next: std_logic_vector(15 downto 0);
    signal o_en_next: std_logic_vector(15 downto 0);
    signal o_we_next: std_logic_vector(15 downto 0);
    signal o_data_next: std_logic_vector(15 downto 0);

begin
  process(i_clk,i_rst)
    begin
      if(i_rst='1')
        --reset
      elsif(rising_edge(i_clk))
        --setvalori
      end if;
  end process;

end Behavioral;
