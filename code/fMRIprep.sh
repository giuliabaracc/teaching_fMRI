#!/bin/sh

#  fMRIprep.sh
#  Created by Giulia Baracchini
#

##This script will run fMRIPrep on 1 subject using the containerised version of fMRIPrep (recommended)
#usage: fmriprep-docker [-h] [--version] [-i IMG] [-w WORK_DIR]
#                       [--output-spaces [OUTPUT_SPACES ...]]
#                       [--fs-license-file PATH] [--fs-subjects-dir PATH]
#                       [--config-file PATH] [-d PATH [PATH ...]]
#                       [--use-plugin PATH] [--bids-database-dir PATH]
#                       [--bids-filter-file PATH]
#                       [--patch PACKAGE=PATH [PACKAGE=PATH ...]] [--shell]
#                       [--config PATH] [-e ENV_VAR value] [-u USER]
#                       [--network NETWORK] [--no-tty]
#                       [bids_dir] [output_dir] [{participant}]

#Set up directories
root_path=/Users/gbar0888/Desktop/Teaching/fMRI_Preprocessing_Connectivity_rest/Practice/ #this is the top level of where all our files live
rawdata_path=${root_path}data/ #this is where your original unpreprocessed data live
outputdata_path=${root_path}workdir/ #this is where fMRIPrep will save all intermediate files while it is preprocessing your data
task_name="rest" #the task label you want to preprocess
freesurferlicense_path=${root_path}freesurfer.txt #you need to have the freesurfer license in there
#note that here we are asking fMIRPrep to not run Freesurfer to speed things up
#check the documentation for an exhaustive explanation of all commands

echo "Data input ${rawdata_path}"
echo "Data output ${outputdata_path}"

export DOCKER_DEFAULT_PLATFORM=linux/amd64 #this is what my MacOS system uses

#Run fmriprep command
fmriprep-docker ${rawdata_path} ${outputdata_path} --skip_bids_validation --participant_label 003 -t ${task_name} --fs-license-file ${freesurferlicense_path} \
--output-spaces MNI152NLin2009cAsym --fs-no-reconall -w ${outputdata_path}

echo "DONE"
