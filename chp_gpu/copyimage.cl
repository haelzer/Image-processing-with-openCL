/// kernel for copying an image
/// This kernel may be modified in order to get filter coefficients. Do not forget to modify the
/// calling function and specify the parameters
///
/// imageInput:  pointer to image data
/// imageOutput: pointer to image result
/// width:       dimension of image
/// height:      dimension of image
/*
### Consignes d'execution, après compilation (lire le fichier README pour la compilation)

```
Pour le filtre moyenneur :
./imageCopyFilter  n -k moyenne
Pour le filtre gaussien :
./imageCopyFilter n sigma -k gauss
Les paramètres:
n désigne l'entier taille de la fenêtre
sigma désigne le flottant paramètre sigma dans la formule de la fonction gaussienne. Il ne faut pas saisir le paramètre sigma si l'on appelle le kernel moyenneur, elle ne prend en entrée que l'entier n.

```
*/


kernel void gauss(__global const unsigned char *imageInput,
           __global       unsigned char *imageOutput,
           int width, int height , int n, __constant float* expo, float sigma) 
{
  float c;
  float dg=0;
  // Get the index of the current element to be processed
  int2 coord = (int2)(get_global_id(0), get_global_id(1));

  // associate a pixel of the image with a work-item: this is done with the computation of index
  // pay attention : RGBa data is stored, this implies the use of 4 uchar variables by pixel
  int rowOffset = coord.y * width * 4;
  int index = rowOffset + coord.x * 4;

  
  if (coord.x < width && coord.y < height)
    {
      float r     = imageInput[index];
      float g     = imageInput[index + 1];
      float b     = imageInput[index + 2];
      float alpha = imageInput[index + 3];
      if ( n < coord.x && coord.x < (width - n) && n < coord.y && coord.y < (height - n)) {
        for (int l = (-n); l <=n ; l++) {
          for (int m = (-n); m <=n ; m++) {
            int index2 = index + 4*(m*width + l);
            c = (expo)[abs(l)]*(expo)[abs(m)];
            dg += c ;
            r     += c*imageInput[index2];
            g     += c*imageInput[index2 + 1];
            b     += c*imageInput[index2 + 2];
            alpha += c*imageInput[index2 + 3];
          }
        }
      }
      
      imageOutput[index]     = (int) ((r - imageInput[index])/dg);
      imageOutput[index + 1] = (int) ((g - imageInput[index + 1])/dg);
      imageOutput[index + 2] = (int) ((b - imageInput[index + 2])/dg);
      imageOutput[index + 3] = (int) ((alpha - imageInput[index + 3])/dg);
    }
}



kernel void moyenne(__global const unsigned char *imageInput,
           __global       unsigned char *imageOutput,
           int width, int height, int n) 
{ float dm = (2*(n) + 1)*(2*(n) + 1);
  // Get the index of the current element to be processed
  int2 coord = (int2)(get_global_id(0), get_global_id(1));

  // associate a pixel of the image with a work-item: this is done with the computation of index
  // pay attention : RGBa data is stored, this implies the use of 4 uchar variables by pixel
  int rowOffset = coord.y * width * 4;
  int index = rowOffset + coord.x * 4;
  
  if (coord.x < width && coord.y < height) {
      float r     = imageInput[index];
      float g     = imageInput[index + 1];
      float b     = imageInput[index + 2];
      float alpha = imageInput[index + 3];

      if ( n < coord.x && coord.x < (width - n) && n < coord.y && coord.y < (height - n)) {
        for (int l = (-n); l <=n ; l++) {
          for (int m = (-n); m <= n ; m++) {
            int index2 = index + 4*(m*width + l);
            r     += imageInput[index2];
            g     += imageInput[index2 + 1];
            b     += imageInput[index2 + 2];
            alpha += imageInput[index2 + 3];
          }
        }
      }

      imageOutput[index]     = (int) (r - imageInput[index])/dm;
      imageOutput[index + 1] = (int) (g - imageInput[index + 1])/dm;
      imageOutput[index + 2] = (int) (b - imageInput[index + 2])/dm;
      imageOutput[index + 3] = (int) (alpha - imageInput[index + 3])/dm;
    }
}
