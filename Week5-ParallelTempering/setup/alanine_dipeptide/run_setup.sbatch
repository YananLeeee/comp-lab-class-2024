#!/bin/bash

#SBATCH --nodes=1                     # Request 1 node
#SBATCH --ntasks-per-node=3            # Request 3 tasks per node
#SBATCH --cpus-per-task=1              # Request 1 CPU per task
#SBATCH --time=24:00:00                # Maximum runtime of 24 hours
#SBATCH --mem=12GB                     # Memory allocation
#SBATCH --job-name=gromacs_replica     # Job name


# Load the GROMACS 2018 module
module load gromacs/openmpi/intel/2018.3

# Define directories for each temperature
TEMPERATURE_DIRS=("T300" "T400" "T600")

# Define the simulation parameters
OUTPUT_NAME="adp_exchange3temps"
STEPS=500    # Number of steps between exchanges (every 500 steps or 1 ps if timestep is 2 fs)

# Ensure the directories exist and contain the required adp.tpr files
for DIR in "${TEMPERATURE_DIRS[@]}"; do
    if [ ! -d "$DIR" ]; then
        echo "Directory $DIR not found. Please make sure the directories are properly set up."
        exit 1
    fi
    if [ ! -f "$DIR/adp.tpr" ]; then
        echo "File adp.tpr not found in $DIR. Make sure the .tpr files are in the directories."
        exit 1
    fi
done

# Run the parallel tempering simulation using mpirun
echo "Running parallel tempering simulation across ${TEMPERATURE_DIRS[*]}..."
mpirun -np 3 gmx_mpi mdrun -s adp -multidir T300/ T400/ T600/ -deffnm "$OUTPUT_NAME" -replex $STEPS

# Check if the simulation ran successfully
if [ $? -eq 0 ]; then
    echo "Simulation completed successfully."
else
    echo "Simulation failed. Please check the error messages."
    exit 1
fi

# Check the exchange probabilities from the log files
echo "Checking exchange probabilities from log files..."
for DIR in "${TEMPERATURE_DIRS[@]}"; do
    LOG_FILE="$DIR/${OUTPUT_NAME}.log"
    if [ -f "$LOG_FILE" ]; then
        echo "Exchange probabilities in $DIR:"
        grep "Repl exchange probability" "$LOG_FILE"
    else
        echo "Log file $LOG_FILE not found."
    fi
done

echo "All log files checked. Review the probabilities to ensure they're within a good range (20-40%)."
