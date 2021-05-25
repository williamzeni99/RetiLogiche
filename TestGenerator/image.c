#include <stdio.h>
#include <stdlib.h>
#include <math.h>
#include <time.h>
#include <string.h>

int* createimage(int dim);
int* calcnewimage(int* values,int dim);
int calcpixel(int curr_pixel, int delta, int min);

void main(int argc, char const *argv[]) {

  FILE *in;
  int *values;
  int *results;
  int row;
  int col;
  float step;
  char filename[300];

  char bfigure[100]="\\begin{figure}[h]\n";
  char efigure[100]="\\end{figure}\n";
  char btikz[100]="\\begin{tikzpicture}\n";
  char etikz[100]="\\end{tikzpicture}\n";
  char bsubfig[100]="\\begin{subfigure}[b]{0.4\\linewidth}\n";
  char esubfig[100]="\\end{subfigure}\n";
  char precap[100]="\\caption{Pre-equalizzazione} \\label{FIG}\n";
  char postcap[100]="\\caption{Post-equalizzazione} \\label{FIG}\n";
  char center[100]= "\\centering\n";
  char cleancap[100]="\\captionsetup[subfigure]{labelformat=empty}";


  printf("Inserisci il nome del file >> ");
  scanf("%s",filename );
  printf("Inserisci le dimensioni dell'immagine e lo step (formato input: n_row n_col step(float cm)) >> ");
  scanf("%d %d %f", &row, &col, &step);
  strcat(filename, ".txt");
  in=fopen(filename,"w");

  printf("\n Valori ottenuti: %s\t%d\t%d\n",filename,row, col );

  srand(time(NULL));
  if(in){
    fprintf(in,"%s",bfigure);
    fprintf(in,"%s",center);
    fprintf(in,"%s",cleancap);
    fprintf(in, "%s",bsubfig);
    fprintf(in,"%s",btikz);
    fprintf(in,"\\draw[step=%fcm,gray,very thin] (0,0) grid (%f,%f);\n",step,(float)col*step,(float)row*step);
    values=createimage(row*col);
    results=calcnewimage(values,row*col);

    for(int i=0; i<row*col;i++){
      printf("%d\t%d\n",values[i],results[i]);
    }

    for(int i=0, k=0; i<col; i++){
      for(int j=0; j<row; j++,k++){
          fprintf(in, "\\fill[mycolor%d] (%f,%f) rectangle (%f,%f);\n",values[k],(float)j*step,(float)i*step, (float)j*step+step,(float)i*step+step );
      }
    }
    fprintf(in, "%s",etikz );
    fprintf(in, "%s",center);
    fprintf(in, "\\caption{Pre-equalizzazione %dx%d} \\label{FIG}\n",row,col);
    fprintf(in, "%s",esubfig);
    fprintf(in, "%s",bsubfig);
    fprintf(in,"%s",btikz);

    fprintf(in,"\\draw[step=%fcm,gray,very thin] (0,0) grid (%f,%f);\n",step,(float)col*step,(float)row*step);
    for(int i=0, k=0; i<col; i++){
      for(int j=0; j<row; j++, k++){
        fprintf(in, "\\fill[mycolor%d] (%f,%f) rectangle (%f,%f);\n",results[k],(float)j*step,(float)i*step, (float)j*step+step,(float)i*step+step );
      }
    }
    fprintf(in, "%s",etikz );
    fprintf(in, "%s",center);
    fprintf(in, "\\caption{Post-equalizzazione %dx%d} \\label{FIG}\n",row,col);
    fprintf(in, "%s",esubfig);
    fprintf(in, "%s",efigure);
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

  printf("Max  min delta: %d %d %d\n",max, min, max-min );

  for (int i = 0; i < dim; i++) {
    results[i]=calcpixel(values[i], max-min, min);
  }
  return results;
}


int calcpixel(int curr_pixel, int delta, int min){
  int shift_level, temp_pixel;

  shift_level=8-(int)log2((double)delta+1);
  printf("Shift: %d\n",shift_level );
  temp_pixel=(curr_pixel-min)<<shift_level;
  if(temp_pixel>255){
    temp_pixel=255;
  }
  return temp_pixel;

}
