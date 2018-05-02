#__author__ = "Paolo Ventriglia"
#__credits__ = ["Paolo Ventriglia"]
#__license__ = "GPL"
#__version__ = ""
#__maintainer__ = "Paolo Ventriglia"
#__email__ = "paolo@corebox.co.uk"

import os

""" 
Renames the filenames within the same directory to be Unix friendly
(1) Changes spaces to hyphens
(2) Makes lowercase (not a Unix requirement, just looks better ;)
Usage:
python rename.py
"""

path =  os.getcwd()
filenames = os.listdir(path)

for filename in filenames:
    os.rename(filename, filename.replace(" ", "-").lower())