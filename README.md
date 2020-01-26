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
### Related Scripts

``RUN_INDEPENDENT_ESTIMATION.sh`` :  Bash script to run the independent parameter estimation, and generate the time series predictions using the estimated parameters.
``RUN_SIMULTANEOUS_ESTIMATION.sh`` : Bash script to run the simultaneous parameter estimation, and generate the time series predictions using the estimated parameters.

### Workflow

1) Open the Terminal
2) Go to the directory you have cloned the repository. Considering the example above, go to the ``ROBOT`` folder,

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

