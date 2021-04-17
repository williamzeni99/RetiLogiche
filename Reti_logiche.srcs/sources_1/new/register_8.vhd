----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 03/29/2021 11:12:29 AM
-- Design Name: 
-- Module Name: register_8 - Behavioral
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

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx leaf cells in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity register_8 is
    Port ( input : in std_logic_vector(7 downto 0);
           release : in STD_LOGIC :='0';
           rst : in STD_LOGIC;
           output : out std_logic_vector(7 downto 0));
end register_8;

architecture Behavioral of register_8 is

begin
    process(release,rst)
    begin
        if rst = '1' then
            output<= (others => '0');
        elsif release'event then
            output<=input;
        end if;
    end process;

end Behavioral;

--coomento
