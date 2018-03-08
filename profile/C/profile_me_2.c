#include <stdlib.h>
#include <stdio.h>
#include <math.h>

int main( int argc, char * argv[] )
{

  double * a, * b, * c;
  double alpha;

  int i;
  
  size_t dim;
  
  //dim = atoi(argv[1]);
  dim = 10000000;
 
  a = (double *) malloc( dim * sizeof( double ) );
  b = (double *) malloc( dim * sizeof( double ) );
  c = (double *) malloc( dim * sizeof( double ) );

  for( i = 0; i < dim; i++ ){

    a[i] = 1.0;
    b[i] = 2.0;
    c[i] = 3.0;
  }

  for( i = 0; i < dim; i++ ){
    
    a[i] = exp( a[i] * i );
  }

  for( i = 0; i < dim; i++ ){
    
    a[i] = sqrt( a[i] * i );
  }

  for( i = 0; i < dim; i++ ){
    
    a[i] = sin( a[i] * i );
  }

  alpha = 0.0;
  for( i = 0; i < dim; i++ ){
    alpha += a[i] + b[i] + c[i];
  }

  printf( "%g", alpha );

  free( a );
  free( b );
  free( c );

  return 0;
}
    
