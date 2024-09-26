#!/bin/bash
SBATCH --nodes=1
SBATCH --ntasks-per-node=1
SBATCH --cpus-per-task=24
SBATCH --time=24:00:00
SBATCH --mem=100GB
SBATCH --job-name=gromacs
SBATCH --mail-type=END
SBATCH --mail-user=yl12451@nyu.edu
SBATCH --output=slurm_%j.out

module purge
module load gromacs/openmpi/intel/2020.4

# Change to the directory where your files are located
cd /home/yl12451/comp-lab-class/comp-lab-class-2024/Week3-IntroToMD

# Prepare the run
gmx_mpi grompp -f md.mdp -c npt.gro -t npt.cpt -p topol.top -o md_0_1.tpr

# Run the simulation
gmx_mpi mdrun -deffnm md_0_1