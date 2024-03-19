This folder contains the MATLAB scripts to perform individual and family level Bayesian Model Selection. This step is performed after the MCRL models are fit to the individual participants' data, and a CSV file is created from the notebook `analysis/Model Analysis.ipynb`.

Firstly, spm12 needs to be installed (see instructions https://www.fil.ion.ucl.ac.uk/spm/software/spm12/)

The spm12 folder and its subdirectories must be present in the MATLAB path before running the scripts.

Then, in the files `spm12/spm_BMS.m` and `spm12/spm_compare_families.m`, the following line must be added following the preamble of the function:

`lme = -0.5 * lme`

Generate several bootstrapped BIC datasets using the notebook `analysis/Model Analysis.ipynb`. Each file must have the name <code><condition>_bic_<numevals>_<dataset#>.csv</code>. All datasets must be stored in the folder `bic_datasets`

where `<condition>` is `control` or `scarce`, `<numevals>` represents the number of optimization evaluations used during model fitting, and `<dataset#>` is the number of the dataset.

The script run_datasets.m performs Bayesian model selection for several datasets. Run this script with the arguments `<start>` <end> <condition> <numevals>`, where `<start>` represents the number of the first dataset and `<end>` represents the number of the last dataset. For example, if `start = 5` and `end = 10`, the script performs the analysis for datasets 5 through 10.

All results are output as XML files to folder `comp_results`.

