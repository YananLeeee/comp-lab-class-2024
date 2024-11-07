#!/bin/bash
#SBATCH --job-name=production_runs
#SBATCH --nodes=1
#SBATCH --ntasks-per-node=4
#SBATCH --cpus-per-task=1
#SBATCH --time=03:20:00
#SBATCH --mem=4GB


source /scratch/work/courses/CHEM-GA-2671-2024fa/software/lammps-gcc-30Oct2022/setup_lammps.bash

# Step: Run production simulations at each temperature
temperatures=("1.5" "1.0" "0.9" "0.8" "0.7" "0.65" "0.6" "0.55" "0.5" "0.475")

for temp in "${temperatures[@]}"
do
    mpirun lmp -var configfile ./n360/kalj_n360_T${temp}.lmp -var id 1 -in ./production_3d_binary.lmp
done

echo "Production runs completed."