<!--
- SPDX-License-Identifier: CC-BY-4.0
- Copyright (C) 2024 Jayesh Badwaik <j.badwaik@fz-juelich.de>
-->

# simple-scaler

`simple-scaler` is a synthetic benchmark that always runs for approximately 10 seconds but reports a
fictional runtime given by the formula below in python notation. Various behaviors of benchmarks,
which are relevant to the purposes of reporting, can be simulated by changing the parameters of the
formula. We arbitrarily fix the weak scaling efficency of the benchmark to be $k^{\log_2(n)}$.

```python
runtime = random(0.95,1.05) *  m * g * c * v *  p * pow(k,log(n,2))
# n : number of MPI ranks
# p : problem size
# k : scaling factor
# m : mpi factor (1.2 for OpenMPI, 1.4 for MPICH/PSMPI)
# g : cuda factor (1.2 for no GPU, 1.4 for GPU)
# c : compiler factor (1.2 for GCC, 1.4 for LLVM, 1.6 for NVHPC)
# v : version factor (random number between 0.8 and 1.2 for different versions)
```


