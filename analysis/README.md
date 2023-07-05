This directory contains analysis notebooks for the preprocessing and analysis of participant data.

How to run:
* create python virtual environment
  * `python3 -m venv env`
* Activate virtual environment
  * `source env/bin/activate`
* Install the `mouselab` package
  * `pip install -e .`
* Install other necessary packages for notebooks
  * `pip install csv pickle pandas numpy matplotlib jupyter statsmodels scipy scikit-learn pymongo`
* Open jupyter notebook
  * `jupyter notebook`
* Open any one of the following notebooks
  * Preprocessing - Preprocessing of raw PostGRES data, analysis of demographic data, and calculation of Prolific bonuses
  * Data Analysis - Statistical analyses of participant data
  * Model Analysis - Analyses of fitted models
* Run the cells of the notebook in order

Participant data should be present in the `results` folder of the root directory. Contact the experimenter for access to the dataset in the appropriate format.