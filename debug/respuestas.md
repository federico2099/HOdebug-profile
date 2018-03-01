Programa: add_array_segfault.c 

Compilo:
gcc -c add_array_segfault.c -o add_array_segfault_c.o

Me devuelve un warning.
add_array_segfault.c: In function ‘add_array’:
add_array_segfault.c:7:12: warning: implicit declaration of function ‘abs’ [-Wimplicit-function-declaration]
     sum += abs(a[i]);

Por lo tanto la compilación se da cuenta de un posible probelma. Al linkear no hay inconvenientes.

Corriendo gdb sin flags de compilación para "debuggeo" me devuelve:

Starting program: /home/fido/Escritorio/Hands_On_wtpc2018/HOdebug-profile/debug/bugs/add_array_segfault.e 

Program received signal SIGSEGV, Segmentation fault.
0x00000000004005eb in main ()

Ahora la agrego los flags "-g -Wall", corro el gdb y me devuelve:
Al compilar me devuelve:

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

Entonces esto me da la pauta que hay problemas en la inicialización de las variables a y b.i Luego,
al correr gdb obtengo el segmentation fault con la línea 9 como responsable:


Program received signal SIGSEGV, Segmentation fault.
0x00000000004005eb in main (argc=1, argv=0x7fffffffd9a8) at add_array_segfault.c:19
19	    b[i] = i;

Con esto ya se que hay un problema en la línea 19

