
#!/bin/bash
# CREATE DIRECTORIES FOR DIFFERENT EXPERIMENTAL SCENARIOS
directory_simulation_results=./SIMULATION_RESULTS
cd $directory_simulation_results
# EXP_0 : Scenario 0 (no inflow of resistance)
# EXP_1 : Scenario I (inflow of both single resistances)
# EXP_2 : Scenario II (inflow of both single resistances and double resistance)
mkdir EXP_0
# NAVIGATE BACK UP ONE DIRECTORY TO RUN THE CODE
cd ..
# LET THE CODE KNOW WHICH SCENARIO YOU WANT TO ESTIMATE THE PARAMETERS FOR
# commIdx=0 : Scenario 0 (no inflow of resistance)
# commIdx=1 : Scenario I (inflow of both single resistances)
# commIdx=2 : Scenario II (inflow of both single resistances and double resistance)
commIdx=0

# LOAD YOUR CURRENT MATLAB MODULE
module load new matlab/R2018a

# NUMBER OF JUMPS AND CHAINS FOR THE MCMC ALGORITHM
njumps=1000
nchains=5
################## SUBMIT INDEPENDENT ESTIMATION ##################

for chainIdx in $(seq 1 ${nchains}); do

bsub -n 1 -W 23:59 -J "I_${chainIdx}" -R "rusage[mem=512]" "matlab -nodisplay -nojvm -singleCompThread -r 'MCMC_ROBOT_INDP_RUN_PARALLEL(${njumps},${nchains},${chainIdx},${commIdx})'"

done
################## INDEPENDENT ESTIMATION JOBS SUBMITTED ##################

pending_I=`bjobs | grep I_ | grep -c  PEND`
running_I=`bjobs | grep I_ | grep -c  RUN`

while [ $((running_I+pending_I)) -gt 0 ]
do

echo "INDPENDENT ESTIMATION JOBS (RUNNING,PENDING) : ${running_I}-${pending_I}"
pending_I=`bjobs | grep I_ | grep -c  PEND`
running_I=`bjobs | grep I_ | grep -c  RUN`
sleep 10

done

echo "ALL INDEPENDENT ESTIMATION JOBS ARE COMPLETE, FILES BEING PROCESSED"

# estTypeIdx=0 -> INDEPENDENT ESTIMATION
# estTypeIdx=1 -> SIMULTANEOUS ESTIMATION

estTypeIdx=0

bsub -n 1 -W 23:59 -J "I_TS" -R "rusage[mem=512]" "matlab -nodisplay -singleCompThread -r 'chains2timeSeries(${njumps},${nchains},${commIdx},${estTypeIdx})'"
