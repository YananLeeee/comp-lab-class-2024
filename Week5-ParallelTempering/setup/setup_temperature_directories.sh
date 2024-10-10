#!/bin/bash

# Exit if any command fails
set -e
set -x  # 追踪每条命令的执行

# Load the GROMACS module
module purge
module load gromacs/openmpi/intel/2018.3

# Create directories for different temperatures
mkdir -p T300 T400 T600

# Copy the necessary files to each directory and rename .mdp files for T400 and T600
cp ./alanine_dipeptide/adp_T300.mdp ./alanine_dipeptide/adp.gro ./alanine_dipeptide/adp.top ./T300/
cp ./alanine_dipeptide/adp_T300.mdp ./alanine_dipeptide/adp.gro ./alanine_dipeptide/adp.top ./T400/
cp ./alanine_dipeptide/adp_T300.mdp ./alanine_dipeptide/adp.gro ./alanine_dipeptide/adp.top ./T600/

# Rename the .mdp files for T400 and T600
mv ./T400/adp_T300.mdp ./T400/adp_T400.mdp
mv ./T600/adp_T300.mdp ./T600/adp_T600.mdp

# Update temperature in the .mdp files for T400 and T600 with flexible space matching
cd ./T400
sed -i "s/ref_t *= *300/ref_t = 363/" ./adp_T400.mdp
sed -i "s/gen_temp *= *300.000/gen_temp = 363.000/" ./adp_T400.mdp
grep "ref_t" ./adp_T400.mdp
grep "gen_temp" ./adp_T400.mdp
cd ..

cd ./T600
sed -i "s/ref_t *= *300/ref_t = 440/" ./adp_T600.mdp
sed -i "s/gen_temp *= *300.000/gen_temp = 440.000/" ./adp_T600.mdp
grep "ref_t" ./adp_T600.mdp
grep "gen_temp" ./adp_T600.mdp
cd ..

# Generate .tpr files using GROMACS grompp for each directory
cd T300
gmx_mpi grompp -f adp_T300.mdp -c adp.gro -p adp.top -o adp.tpr
cd ..

cd T400
gmx_mpi grompp -f adp_T400.mdp -c adp.gro -p adp.top -o adp.tpr
cd ..

cd T600
gmx_mpi grompp -f adp_T600.mdp -c adp.gro -p adp.top -o adp.tpr
cd ..
