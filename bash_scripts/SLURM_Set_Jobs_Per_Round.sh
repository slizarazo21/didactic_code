#!/bin/bash
# ----------------SLURM Parameters----------------
#SBATCH -p normal
#SBATCH -n 1
#SBATCH --mem=10g
#SBATCH -N 1

# Directory containing the .sh files
DIR="Your_Directory"

# Find all .sh files in the directory and store them in an array
files=($(find "$DIR" -type f -name "*.sh"))

# Batch size
BATCH_SIZE=30

# Loop through all files in batches
for ((i=0; i<${#files[@]}; i+=BATCH_SIZE)); do
    # Initialize an array to hold job IDs for this batch
    job_ids=()

    # Submit batch of jobs
    for ((j=i; j<i+BATCH_SIZE && j<${#files[@]}; j++)); do
        # Submit job and capture job ID
        job_id=$(sbatch "${files[$j]}" | awk '/Submitted batch job/ {print $4}')
        # Add job ID to array
        job_ids+=($job_id)
    done

    # Wait for all jobs in the current batch to complete
    for job_id in "${job_ids[@]}"; do
        while : ; do
            # Check if the job is still in the queue
            job_status=$(squeue -j $job_id -h -o %T)
            if [[ $job_status = "" || $job_status = "COMPLETED" || $job_status = "FAILED" || $job_status = "CANCELLED" ]]; then
                # Job is no longer active
                break
            else
                # Wait for a bit before checking again
                sleep 120
            fi
	done
    done
done
