# Eleción de código en C

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



