
 **Compilo código profile_me_1.c sin ningún flag de optimización.**

 **Corro y obtengo** 

real	0m0.877s
user	0m0.818s
sys	0m0.060s

Ahora agrego el flag -pg para poder usar elprofiler **gprof**

real	0m1.638s
user	0m1.574s
sys	0m0.064s

En este caso entiendo que, además de correrse el programa se están corriendo cosas del profiler también.

 **Con el flag -O0**

real	0m0.925s
user	0m0.840s
sys	0m0.084s


 **Con el flag -01**

real	0m0.525s
user	0m0.473s
sys	0m0.052s

 **Con el flag -02**

real	0m0.002s
user	0m0.000s
sys	0m0.002s

 **Con el flag -03**

real	0m0.001s
user	0m0.000s
sys	0m0.001s


 En primer lugar se observa que compilar el programa sin niguna optimización es lo mismo que compilarlo con la
opción -O0. Es decir que esta es la opción por defecto. Luego al aplicarle el flag -O1 se tiene un leve aumento 
en la velocidad de corrida del código. Con el flag -O2 se obtiene un gran aumento (dos órdenes de magnitud) 
mientras que con -O3 no se modifica la velocidad con respecto al uso de -O2. Podría decirse que con el uso del 
flag -O2 ya se logra la mayor optimización posible (mediante estas opciones) del código.

Cuando compilo con el flag -pg me da la opción de usar un profiler. En este caso he usado el profiler gprof.

Para tal motivo compilé de la siguiente manera:

 **gcc profile_me_1.c -pg -o profile_me_1.e**

Luego corro el ejecutable programa profile_me_1.e y se me genera un archivo "gmon.out"

y corro el profiler junto con el ejecutable del programa con la siguiente sentencia:

gprof profile_me_1.e gmon.out > archivo_de_salida_del_profiler.dat

Al analizar el archivo de salida encuentro lo siguiente:

Each sample counts as 0.01 seconds.
  %   cumulative   self              self     total           
 time   seconds   seconds    calls  ns/call  ns/call  name    
 56.09      0.44     0.44 25000000    17.50    17.50  first_assign
 27.08      0.65     0.21                             main
 16.12      0.77     0.13 25000000     5.03     5.03  second_assign

En esta tabla obtengo información de cuánto demora cada proceso tanto en forma absoluta como relativa. En este caso
el proceso de llamar a "first_assign" es el mas demandante. Cada llamado demora más del triple que el llamado a
seccond_assign, por ejemplo. Del tiempo total el 56% del programa se lo pasa ejecutando first_assign. Por lo tanto
ese es el cuello de botella en este programa.

El profiler arroja otra tabla que tiene la siguiente información:

[1]    100.0    0.21    0.56                 main [1]
                0.44    0.00 25000000/25000000     first_assign [2]
                0.13    0.00 25000000/25000000     second_assign [3]
-----------------------------------------------
                0.44    0.00 25000000/25000000     main [1]
[2]     56.5    0.44    0.00 25000000         first_assign [2]
-----------------------------------------------
                0.13    0.00 25000000/25000000     main [1]
[3]     16.2    0.13    0.00 25000000         second_assign [3]
-----------------------------------------------

En este caso es un poco más detallada ya que me dice que función llama a otra. Por ejemplo, "main" llama a 
first_assing y a seccond_assing, sin embargo estas últimas dos funciones no llaman a ninguna otra.

Cuando compilo con el flag -O1 y corro el profiler gprof obtengo

  %   cumulative   self              self     total           
 time   seconds   seconds    calls  ns/call  ns/call  name    
 54.09      0.30     0.30 25000000    11.90    11.90  first_assign
 33.01      0.48     0.18                             main
 13.75      0.55     0.08 25000000     3.03     3.03  second_assign

En este caso se ve que todos los tiempos fueron levemente acelerados, sin embargo en términos relativos cada 
proceso se mantiene mas o menos constante.

Cuando compilo con el flag -O2 y -O3 y corro el profiler gprof obtengo la sentencia

 **"no time accumulated"**





