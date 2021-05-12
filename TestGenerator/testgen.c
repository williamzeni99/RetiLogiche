#include <stdio.h>
#include <stdlib.h>
#include <math.h>
#include <time.h>
#include <string.h>

int* createimage(int dim);
int* calcnewimage(int* values,int dim);
void printTest(FILE *fp,int row, int col, int* values);
int calcpixel(int curr_pixel, int delta, int min);
void printAssert( FILE *fp, int dim, int *results);

void main(int argc, char const *argv[]) {

  FILE *in;
  int *values;
  int *results;
  int row;
  int col;
  char filename[300];

  char entity[2000]="library ieee;\nuse ieee.std_logic_1164.all;\nuse ieee.numeric_std.all;\nuse ieee.std_logic_unsigned.all;\n\nentity project_tb is\nend project_tb;\n\narchitecture projecttb of project_tb is\nconstant c_CLOCK_PERIOD\t: time := 15 ns;\nsignal tb_done\t: std_logic;\nsignal mem_address\t: std_logic_vector (15 downto 0) := (others => '0');\nsignal tb_rst\t: std_logic := '0';\nsignal tb_start\t: std_logic := '0';\nsignal tb_clk\t                 : std_logic := '0';\nsignal mem_o_data,mem_i_data\t: std_logic_vector (7 downto 0);\nsignal enable_wire\t: std_logic;\nsignal mem_we\t: std_logic;\n\ntype ram_type is array (65535 downto 0) of std_logic_vector(7 downto 0);\n\n\0";

  char component[2000]="component project_reti_logiche is port (\n\t\ti_clk\t\t: in  std_logic;\n\t\ti_start\t: in  std_logic;\n\t\ti_rst\t\t: in  std_logic;\n\t\ti_data\t\t: in  std_logic_vector(7 downto 0);\n\t\to_address\t: out std_logic_vector(15 downto 0);\n\t\to_done\t\t: out std_logic;\n\t\to_en\t\t: out std_logic;\n\t\to_we\t\t: out std_logic;\n\t\to_data\t\t: out std_logic_vector (7 downto 0)\n\t);\nend component project_reti_logiche;\n\n\0";

  char uut[2000]="begin\nUUT: project_reti_logiche\nport map (\n\t\ti_clk	=> tb_clk,\n\t\ti_start => tb_start,\n\t\ti_rst	=> tb_rst,\n\t\ti_data => mem_o_data,\n\t\to_address	=> mem_address,\n\t\to_done	=> tb_done,\n\t\to_en => enable_wire,\n\t\to_we => mem_we,\n\t\to_data	=> mem_i_data\n\t\t);\n\n";

  char p_CLK_GEN[2000]="p_CLK_GEN : process is\nbegin\n\twait for c_CLOCK_PERIOD/2;\n\ttb_clk <= not tb_clk;\nend process p_CLK_GEN;\n\n";

  char mem[2000]="MEM : process(tb_clk)\nbegin\n\tif tb_clk'event and tb_clk = '1' then\n\t\tif enable_wire = '1' then\n\t\t\tif mem_we = '1' then\n\t\t\t\tRAM(conv_integer(mem_address))  <= mem_i_data;\n\t\t\t\tmem_o_data <= mem_i_data after 1 ns;\n\t\t\telse\n\t\t\t\tmem_o_data <= RAM(conv_integer(mem_address)) after 1 ns;\n\t\t\tend if;\n\t\tend if;\n\tend if;\nend process;\n\n";

  char test[2000]="test : process is\nbegin\n\twait for 100 ns;\n\twait for c_CLOCK_PERIOD;\n\ttb_rst <= '1';\n\twait for c_CLOCK_PERIOD;\n\twait for 100 ns;\n\ttb_rst <= '0';\n\twait for c_CLOCK_PERIOD;\n\twait for 100 ns;\n\ttb_start <= '1';\n\twait for c_CLOCK_PERIOD;\n\twait until tb_done = '1';\n\twait for c_CLOCK_PERIOD;\n\ttb_start <= '0';\n\twait until tb_done = '0';\n\twait for 100 ns;\n\n\n";

  printf("Inserisci il nome del file >> ");
  scanf("%s",filename );
  printf("Inserisci le dimensioni dell'immagine (formato input: n_row n_col) >> ");
  scanf("%d %d", &row, &col);
  strcat(filename, ".vhd");
  in=fopen(filename,"w");

  printf("\n Valori ottenuti: %s\t%d\t%d\n",filename,row, col );

  srand(time(NULL));
  if(in){
    fprintf(in,"%s",entity);
    values=createimage(row*col);
    results=calcnewimage(values,row*col);
    printTest(in, row,col, values);
    fprintf(in,"%s",component);
    fprintf(in, "%s",uut );
    fprintf(in, "%s",p_CLK_GEN );
    fprintf(in, "%s",mem);
    fprintf(in, "%s",test);
    printAssert(in, row*col,results);
    fprintf(in, "\n end process test;\n end projecttb;\n");
    fclose(in);
  }
  else{
    printf("Errore di apertura del file\n");
  }

}

int* createimage(int dim){
  int *values;
  values=(int*) malloc(dim* sizeof(int));
  for (int i = 0; i < dim; i++) {
    values[i]=50+rand() %150;
  }

  return values;
}

int* calcnewimage(int* values,int dim){
  int *results;
  int min=255;
  int max=0;
  results=(int*) malloc(dim*sizeof(int));

  for (int i = 0; i < dim; i++) {
    if(values[i]<min){
      min=values[i];
    }
    if(values[i]>max){
      max=values[i];
    }
  }

  for (int i = 0; i < dim; i++) {
    results[i]=calcpixel(values[i], max-min, min);
  }
  return results;
}

void printTest(FILE *fp,int row, int col, int* values){
  fprintf(fp, "signal RAM: ram_type := (0 => std_logic_vector(to_unsigned(  %d , 8)),\n\t\t\t1 => std_logic_vector(to_unsigned(  %d  , 8)),\n", col, row);
  for(int i=0; i<row*col; i++){
    fprintf(fp, "\t\t\t%d => std_logic_vector(to_unsigned(%d , 8)),\n",i+2, values[i]);
  }
  fprintf(fp, "\t\t\tothers => (others =>'0'));\n\n");
}

int calcpixel(int curr_pixel, int delta, int min){
  int shift_level, temp_pixel;

  shift_level=8-(int)log2((double)delta+1);
  temp_pixel=(curr_pixel-min)<<shift_level;
  if(temp_pixel>255){
    temp_pixel=255;
  }
  return temp_pixel;

}

void printAssert( FILE *fp, int dim, int *results){
  fprintf(fp,"--------ASSERTS--------\n");
  for (int i = 0; i < dim; i++) {
    fprintf(fp,"assert RAM(%d) = std_logic_vector(to_unsigned( %d , 8)) report \"TEST FALLITO (WORKING ZONE). Expected  %d  found \" & integer'image(to_integer(unsigned(RAM(%d))))  severity failure;\n",dim+2+i,results[i], results[i],dim+2+i);
  }
  fprintf(fp, "\nassert false report \"Simulation Ended! TEST PASSATO\" severity failure;\n");
}
