#!/bin/bash
#SBATCH --job-name=create_anneal_kalj
#SBATCH --nodes=1
#SBATCH --ntasks-per-node=4
#SBATCH --cpus-per-task=1
#SBATCH --time=02:30:00
#SBATCH --mem=4GB

# Load LAMMPS environment
source /scratch/work/courses/CHEM-GA-2671-2024fa/software/lammps-gcc-30Oct2022/setup_lammps.bash

# Step 1: Create the system
mpirun lmp -var configfile ./n360/kalj_n360_create.lmp -var id 1 -in ./create_3d_binary.lmp

# Step 2: Progressively equilibrate to lower temperatures
temperatures=("1.5" "1.0" "0.9" "0.8" "0.7" "0.65" "0.6" "0.55" "0.5" "0.475")

for temp in "${temperatures[@]}"
do
    mpirun lmp -var configfile ./n360/kalj_n360_T${temp}.lmp -var id 1 -in ./anneal_3d_binary.lmp
done

echo "System creation and cooling completed."