# didactic_code
This repository has information about different code snippets that are resourceful. It also has an explanation of what the code does It will be constantly growing

Each folder has information about the type of code you can run.

### 1. **bash_scripts** 
   - **SLURM_Multiple_Jobs_Sequence.sh**      
This shell script will run X number of jobs constantly. Let's say that you have 500 shell scripts you want to run, instead of running them all, you can run 20 jobs constantly until all the 500 jobs are completed.  
   - **SLURM_Set_Jobs_Per_Round.sh**     
This shell script will run X number of jobs *at the time*. Let's say you have 500 shell scripts, if you use this code, you will run 20 jobs per round. A new set of 20 jobs will be performed after completing the previous set of 20.
