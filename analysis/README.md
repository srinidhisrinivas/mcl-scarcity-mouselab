This directory contains analysis notebooks for the preprocessing and analysis of participant data.

Some of the notebooks use outputs of model-fitting procedures whose scripts are present in the [mcl_toolbox](https://github.com/srinidhisrinivas/mcl_toolbox) repository.

How to run:
* create python virtual environment
  * `python3 -m venv env`
* Activate virtual environment
  * `source env/bin/activate`
* Install the `mouselab` package
  * `pip install -e .`
* Install other necessary packages for notebooks
  * `pip install -r requirements.txt`
* Open jupyter notebook
  * `jupyter notebook`
* The following notebooks are relevant
  * `Data Analysis.ipynb` - Statistical analyses of participant data
  * `Model Analysis.ipynb` - 
    * Creation of BIC dataframes for model comparison using spm12
    * Analyses of model comparison results from spm12
* Run the cells of the notebook in order

Participant data should be present in the `results/anonymized_data` folder of the root directory. 