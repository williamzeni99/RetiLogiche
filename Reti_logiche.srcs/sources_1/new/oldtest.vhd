library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;


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
 type state_type is (PRIMO,WAITMEM, SECONDO); -- SECONDO, TERZO, QUARTO, WAITMEM);
    signal next_state,curr_state, prev_state: state_type;
    
    signal address: std_logic_vector(15 downto 0);
    signal righe: std_logic_vector(7 downto 0);
    signal righe_cp: std_logic_vector(7 downto 0);
    signal colonne: std_logic_vector(7 downto 0);
    signal abilita: std_logic;
    signal done_cp: std_logic;
    
begin

process(i_clk,i_rst)
    begin
      if(i_rst='1') then
        address<=(others=>'0');
        righe<=(others=>'0');
        colonne<=(others=>'0');
        curr_state<=PRIMO;
        abilita<='0';
        done_cp<='0';
        
      elsif(i_clk'event and i_clk='1') then
        o_address<=address;
        prev_state<=curr_state;
        --o_en<=abilita;
        curr_state<=next_state;
       -- o_done<=done_cp;
       righe<=righe_cp;
        
      end if;
  end process;
  
  process(i_start, curr_state)
     begin
        case curr_state is
        when PRIMO =>
            if(prev_state=WAITMEM) then
                righe_cp<=i_data;
                next_state<=SECONDO;
            else if(i_start='1') then
                o_en<='1';
                address<=(others=>'0');
                next_state<=WAITMEM;
                end if;
            end if;
            
         when WAITMEM=>
            if(prev_state=PRIMO) then
                next_state<=PRIMO;
                o_en<='0';
            end if;
          
          when SECONDO=>
            o_en<='1';
            address<= (0=>'1'),(others=>'0');
            next_state<=WAITMEM
     
           end case;
           end process;
end Behavioral;
