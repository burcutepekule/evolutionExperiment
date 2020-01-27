# Parameter estimation for the long-term serial passage evolution experiment
Parameter estimation repository for the manuscript _"Testing strategies to reduce antibiotic resistance by liquid handling robotics"_  by Daniel C. Angst, Burcu Tepekule, Balazs Bogos, Lei Sun, Sebastian Bonhoeffer.

# Getting started

Bash scripts in this repository are specifically organized to work in an LSF batch system that has a MATLAB module. MATLAB codes can be used locally without the bash scripts. 

### Cloning the repository
1) Open the Terminal and ssh to your LSF batch system.
2) Go to the directory you wish to clone the repository. As an example, you can create a new directory called ``ROBOT``  first,

```sh 
$ mkdir ROBOT
```

go to that folder

```sh 
$ cd ./ROBOT/
```

and then clone the repository by typing the following

```sh 
$ git clone https://github.com/burcutepekule/evolutionExperiment.git
```
You will have a folder named ``evolutionExperiment`` in your new ``ROBOT`` folder including all files necessary to run the simulations.

# Running Simulations & Data Processing
### Bash Scripts

``RUN_INDEPENDENT_ESTIMATION.sh`` :  Bash script to run the independent parameter estimation, and generate the time series predictions using the estimated parameters.<br/>
``RUN_SIMULTANEOUS_ESTIMATION.sh`` : Bash script to run the simultaneous parameter estimation, and generate the time series predictions using the estimated parameters.

### MATLAB Functions

``MCMC_ROBOT_INDP_RUN_PARALLEL(njumps,nchains,chainIdx,commIdx)`` :  The main MATLAB function that runs the MCMC algorithm for independent estimation. It runs one chain at a time, and it is used in a for loop in the bash script to run as many chains in parallel as the user wants. It takes 4 inputs, 

``njumps`` : Number of jumps per Markov chain.<br/>
``nchains``: Number of chains to be run in parallel in total. (This is required for the proper naming of the folders).<br/>
``chainIdx``: Index of the chain that is currently being run. (This is required for the proper naming of the files, and to change the seed for the random number generator.)<br/>
``commIdx``: This is the "community index". As mentioned in the manuscript, there are 3 different experimental scenarios with different community composition. To run the code for each scenario, manipulate the ``commIdx`` variable as described below. 

| ``commIdx``   | Scenario | 
| ------------- |-------------| 
| 0 | Scenario ∅ : no inflow of resistance | 
| 1 | Scenario I : inflow of both single resistances | 
| 2 | Scenario II : inflow of both single and double resistances | 

``RUN_MCMC_ALL_INDP_PARALLEL(readDataDirec,commIdx,therapy,offset,LB,UB,x0,burnin,sampleevery,njumps,kernel,sig,filname)`` : MATLAB function that sets the options for the Metropolis-Hastings algoritm to run. It takes 13 inputs, 

``readDataDirec`` : Directory to read the experimental data from. <br/>
``commIdx``: Community index (explained above). <br/>
``therapy``: Index of the treatment arm that will be used for parameter estimation. (These indexes are used within the other functions as well to indicate a certain treatment.) <br/>


| ``therapy``   | Treatment | 
| ------------- |-------------| 
| 1 | no treatment | 
| 2 | mono A | 
| 3 | mono B | 
| 4 | combination | 
| 5 | cycling | 
| 6 | mixing | 


``offset``: Offset value for transfer index of the time series. If ``offset=0``, all data points will be used for parameter estimation, including transfer 0. ``offset=1`` is used during the parameter estimations since the first data point of the time series represent the initial conditions, which is separately indicated for the differential equation solver. <br/>
``LB`` : Lowerbound vector of the prior distribution of the parameters, set to 0.<br/>
``UB`` : Upperbound vector of the prior distribution of the parameters, set to 0 (See the manuscript, all parameters have a uniform prior distribution in the open interval of (0,1)).<br/>
``x0`` : Initial guess vector for the parameters (set to ``(LB+UB)/2``).<br/>
``kernel`` : Index to choose the transition kernel for the Metropolis-Hastings algorithm. ``kernel=0`` uses a Uniform transition kernel, whereas ``kernel=1`` uses a Gaussian one. ``kernel=1`` is used in the code for the estimations. <br/>
``sig``: Standart deviation for the transition kernel (set to ``(UB-LB)/6)`` to satisfy the 3 sigma rule). <br/>
``filname`` : Filename to save the Markov chain. 

``mh_INDP(kernel,sig,y,x0,@(x)(fhngen_ROBOT_ALL(x,opt)),LB,UB,params)`` : MATLAB function that runs the Metropolis-Hastings algorithm. The only input that it additionally takes is the function generator ``fhngen_ROBOT_ALL``, explained below. 

``fhngen_ROBOT_ALL(x,opt)`` : MATLAB function that sets the options for the dynamical system to run, which is contained in hte function  ``fhn_ROBOT_ALL(t,x,opt)``, explained below.

``fhn_ROBOT_ALL(t,y,opt)`` : MATLAB function that contains the ordinary differential equation (ODE) system of the dynamical model (see Supplementary Information, Eqns (1)-(5)). 

``setDrugPressure(therapyIdx,offset,T)`` : MATLAB function that generates the drug pressure vector for a given treatment arm.  It takes 3 inputs, 

``therapyIdx``: Index of the treatment arm that will be used (refer to the table above).

### Workflow

1) Open the Terminal
2) Go to the directory you have cloned the repository. Considering the example above, go to the ``ROBOT/evolutionExperiment`` folder,

```sh 
$ cd ./ROBOT/evolutionExperiment/
```
3) Give permission to the bash script (depending on the estimation you will run, here, it is demonstrated for independent estimation) by typing the following

```sh
$ chmod +x ./RUN_INDEPENDENT_ESTIMATION.sh
```

4) Run the bash script by typing the following 

```sh
$ ./RUN_INDEPENDENT_ESTIMATION.sh
```
The bash script will read the necessary data from the subfolder called ``EXPERIMENTAL_DATA``, and will save the estimation results to the subfolder called ``SIMULATION_RESULTS``. 

### Naming of the subfolders


## APPENDIX

