# Ejercicio profileme-1.c

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

# CONSULTAR SI ESTO SE DEBE A QUE EL PROGRAMA CORRE MUY RAPIDO POR ESO NO REGISTRA TIEMPO (NO CREO QUE SEA ASI)

# PROFILING PROGRAMAS FORTRAN

En este caso realicé el profiling de los códigos "1-loop-interch.f90" y "2-gprof-ex.f90". Estos códigos básicamente
hacen lo mismo, que es sumar 3 arrays, a, b y c, cada uno de dimensión (5000,5000) y un "float" alpha. La suma la 
realizan 4 veces en total, 2 veces de manera eficiente y 2 de manera ineficiente. La manera eficiente de sumar en
los arrays en FORTRAN es sumar los elementos de las filas de una misma columna. Esto es así porque es la manera que
en FORTRAN se organizan los elementos en los espacios de memoria asignados. Entonces cuando se cargan en Cache los 
valores correspondientes a los espacios de memoria asignados a los arrays, resulta más eficiente sumar las filas 
de una misma columna porque los datos están más accesibles que si se sumaran los elementos de las distintas columnas 
para una misma fila. En este último caso podría ocurrir que no se carguen los arrays completos en Caché entonces 
se tendrían que tomar algunos elementos de columnas para una misma fila, luego el caché debería ser "liberado" para 
ir a "buscar" otros elementos y luego se debería realizar otro paso de liberación/búsqueda, y así sucesivamente hasta
terminar la operación que se esté realizando. Esto resulta menos eficiente en tiempo y costo computacional.
La diferencia entre ambos códigos radica en que el 1-loop-interch.f90 tiene solamente un main en donde se llevan 
a cabo todas las operaciones, mientras que el "2-gprof-ex.f90 llama a subrutinas good_assign y bad_assign para 
realizar las sumas de manera eficiente e ineficiente, respectivamente. 

 Para demostrar la diferencia entre la manera eficiente e ineficiene de acomodar los índices, decidí "partir" el 
código 1-loop-interch.f90 y generar dos códigos, uno con la parte GOOD y otro con la BAD y lo compilé con distintos
flags de optimización los resultados obtenidos fueron:

					**-O0 Flag**

			**GOOD**					**BAD**

% cumulative   self     self     total %cumulative self  | % cumulative self     self     total %cumulative self
   time      seconds   seconds    calls  ms/call  ms/call|    time   seconds   seconds    calls  ms/call  ms/call 
  100.29     **0.45**  **0.45**     1    451.30   451.30 | 100.29   **0.98**   **0.98**     1   982.82   982.82

					**-O1 Flag**

% cumulative   self     self     total %cumulative self  | % cumulative self     self     total %cumulative self
   time      seconds   seconds    calls  ms/call  ms/call|    time   seconds   seconds    calls  ms/call  ms/call
100.72      **0.16**   **0.16**     1    161.15   161.15 |  100.72   **0.50**  **0.50**     1   503.60   503.60  

                                        **-O2 Flag**

% cumulative   self     self     total %cumulative self  | % cumulative self     self     total %cumulative self
   time      seconds   seconds    calls  ms/call  ms/call|    time   seconds   seconds    calls  ms/call  ms/call
  95.13      **0.17**  **0.17**                          |   99.76   **0.52**  **0.52** 

                                        **-O3 Flag**

% cumulative   self     self     total %cumulative self  | % cumulative self     self     total %cumulative self
   time      seconds   seconds    calls  ms/call  ms/call|    time   seconds   seconds    calls  ms/call  ms/call
100.38       **0.11**  **0.11**                                |   100.49  **0.22**  **0.22**


A partir de estos resultados resalta el hecho que, si bien al aumentar el criterio de optimización, ambos códigos
se vuelven más rápidos, el que realiza la suma de manera eficiente siempre es más rápido del que no lo hace.

Ahora presento una comparación análoga pero entre los códigos "1-loop-interch.f90" y "2-gprof-ex.f90".

                                        **-O0 Flag**

% cumulative   self     self     total %cumulative self  |%cumulative self   self     total 
   time      seconds   seconds    calls  ms/call  ms/call|  time    seconds  seconds    calls 
 100.21      1.40      1.40        1     1.40     1.40   |57.84     1.53     1.53    50000000   bad_assign
  -------------------------------------------------------|23.82     2.16     0.63    50000000   good_assign
  -------------------------------------------------------|18.14     2.64     0.48        1      MAIN

                                        **-O1 Flag**

% cumulative   self     self     total %cumulative self  |%cumulative self   self     total 
   time      seconds   seconds    calls  ms/call  ms/call|  time    seconds  seconds    calls 
 100.49      0.69      0.69        1     1.40     1.40   | 49.58     0.42     0.42   50000000   bad_assign
  -------------------------------------------------------| 27.15     0.65     0.65       1      MAIN
  -------------------------------------------------------| 17.71     0.80     0.80   50000000   good_assign


 Con los flags -O2 y -O3 lo que ocurre es que el compilador elimina las subrutinas del código 2-gprof-ex.f90 
y pone todo en el main. (Muestro solo con el flag -O3)

                                        **-O3 Flag**

% cumulative   self     self     total %cumulative self  |%cumulative self   self     total
   time      seconds   seconds    calls  ms/call  ms/call|  time    seconds  seconds   calls
100.25      0.31     0.31                           MAIN |  100.24      0.31     0.31             MAIN

Puede verse en los casos sin glags de optimización y con O1, el código con subrutinas es menso eficiente
que el que tiene solo MAIN. Esto se debe a que el hecho de llamar a una función o subrutina tiene un costo 
computacional ya que las variables que se definan en la nueva subrutina estarán asignadas en otro espacio de 
memoria. Esto genera a que mientras se ejecuta el programa la computadora tenga que estar buscando los valores
en distintos espacios de memora cuando en realidad podría no hacerlo. Es por ello que cuando se prenden los flags
-O2 y -O3 el compilador se da cuenta de esta ineficiencia y termina escribiendo un código assembler que solo tendrá
MAIN. En consecuencia ambos códigos demorarán lo mismo, como puede observarse para el caso de -O3 Flag puesto mas
arriba
