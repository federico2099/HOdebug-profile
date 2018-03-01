# Programa: add_array_segfault.c 

**Compilo:**
gcc -c add_array_segfault.c -o add_array_segfault_c.o

**Me devuelve un warning.**
add_array_segfault.c: In function ‘add_array’:
add_array_segfault.c:7:12: warning: implicit declaration of function ‘abs’ [-Wimplicit-function-declaration]
     sum += abs(a[i]);

##Por lo tanto la compilación se da cuenta de un posible probelma. Al linkear no hay inconvenientes.
**Corriendo gdb sin flags de compilación para "debuggeo" me devuelve:**

Starting program: /home/fido/Escritorio/Hands_On_wtpc2018/HOdebug-profile/debug/bugs/add_array_segfault.e 

Program received signal SIGSEGV, Segmentation fault.
0x00000000004005eb in main ()

**Ahora la agrego los flags "-g -Wall", corro el gdb y me devuelve:
Al compilar me devuelve:**

add_array_segfault.c: In function ‘add_array’:
add_array_segfault.c:7:12: warning: implicit declaration of function ‘abs’ [-Wimplicit-function-declaration]
     sum += abs(a[i]);
            ^
add_array_segfault.c: In function ‘main’:
add_array_segfault.c:18:6: warning: ‘a’ may be used uninitialized in this function [-Wmaybe-uninitialized]
     a[i] = i;
      ^
add_array_segfault.c:19:6: warning: ‘b’ may be used uninitialized in this function [-Wmaybe-uninitialized]
     b[i] = i;

##Entonces esto me da la pauta que hay problemas en la inicialización de las variables a y b.i Luego,
##al correr gdb obtengo el segmentation fault con la línea 9 como responsable:


Program received signal SIGSEGV, Segmentation fault.
0x00000000004005eb in main (argc=1, argv=0x7fffffffd9a8) at add_array_segfault.c:19
19	    b[i] = i;

##Con esto ya se que hay un problema en la línea 19

# ¿Cuál fue el problema? (Pongo pedazo de código para explicar)
  int *a, *b;
  int n = 3;i
  int i, sum;

Estoy declarando dos punteros (*a y *b), pero no los estoy definiendo ni asignando ningún valor. Es decir, solo 
tienen una memoria de 8 bytes allocateada pero nada mas. No se sabe donde y tampoco tengo idea de como es o va a 
ser "a" y "b" Entonces cuando el programa los vaya a utilizar no sabe que valores tienen ni donde están porque 
tampoco tienen asignado un espacio de memoria. Por eso me tira un segmentation fault, ya que este error está 
asociado a problemas con el espacio de memoria. Otra manera de darme cuenta de esto es cuando incorporo el flag 
-Wall a la compilación.Justamente el **warning que me tira** es que las variables a y b no está inicializadas.

# Solución

Puede solucionarse de dos maneras:

## Manera 1

  int n = 3;  **Defino un entero "n" = 3**
  int a[n], b[n]; **Defino arrays "a" y "b" con dimensión "n"**
  int i, sum;

Acá estoy declarando y definiendo los arrays a y b y además les estoy asignando un espacio de memoria en el **stack**,
para que cada array cuente con 3 elementos, entonces ahora no va a haber problemas para que se les asigne valores

## Manera 2

  int *a, *b; **Defino punteros a y b**
  int n = 3;  **Defino un entero n = 3**
  int i, sum;
  a = malloc(n*sizeof(int)); ** allocateo el array "a" con una dimensión de "n veces" el tamaño de un entero**
  b = malloc(n*sizeof(int)); ** allocateo el array "b" con una dimensión de "n veces" el tamaño de un entero **

 
  free(a)
  free(b)
Sigo declarando a y b como punteros pero luego los "allocateo" memoria en el heap con **malloc** "n veces" 
el tamaño que ocupa un entero que es 4 bytes. Lo que si tengo que tener el cuidado de liberar la memoria 
que asigné dinámicamente para a y b de forma tal que no quede utilizada y esté disponible para ser ocupada
por alguna otra función, array, etc.

# Programa: add_array_static.c


