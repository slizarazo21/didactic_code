
#!/bin/bash
# ----------------SLURM Parameters----------------
#SBATCH -p normal
#SBATCH -n 1
#SBATCH --mem=10g
#SBATCH -N 1

# Directory containing the .sh files
DIR="YOUR/PATHWAY"

# Find all .sh files in the directory and store them in an array
files=($(find "$DIR" -type f -name "*.sh"))

# Maximum number of concurrent jobs
MAX_JOBS=40

# Array to hold job IDs
declare -A job_ids

# Index of the next job to submit
next_job=0

# Function to submit jobs until the maximum is reached or no more jobs are left
submit_jobs() {
    while [ ${#job_ids[@]} -lt $MAX_JOBS ] && [ $next_job -lt ${#files[@]} ]; do
        # Submit job and capture job ID
        job_id=$(sbatch "${files[$next_job]}" | awk '/Submitted batch job/ {print $4}')
        echo "Submitted ${files[$next_job]} with Job ID $job_id"
        # Store job ID in associative array with job_id as key
        job_ids[$job_id]=$next_job
        ((next_job++))
    done
}

# Initial submission
submit_jobs

# Main loop to monitor jobs and submit new ones as needed
while [ ${#job_ids[@]} -gt 0 ]; do
    for job_id in "${!job_ids[@]}"; do
        # Check if the job is still in the queue
        job_status=$(squeue -j $job_id -h -o %T)
        if [[ $job_status = "" || $job_status = "COMPLETED" || $job_status = "FAILED" || $job_status = "CANCELLED" ]]; then
            # Job is no longer active, remove from the list
            unset job_ids[$job_id]
            echo "Job $job_id completed or failed."
        fi
    done
    # Submit new jobs if there are slots available
    submit_jobs
    # Wait before checking again to avoid overwhelming SLURM
    sleep 300
done

echo "All jobs are done"
