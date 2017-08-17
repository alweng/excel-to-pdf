#!/usr/bin/env python2

## Converts all PDF files in the directory pdfPath 
## to eps files in the directory epsPath

import sys
from glob import *
import os

# check that first two arguments are directories
if len(sys.argv)!=4:
    print("Usage: %s pdfPath epsPath envPath" % sys.argv[0])
    exit(1)

for i in range(1,2):
    if not os.path.isdir(sys.argv[i]):
        print('"{0}" is not a file path'.format(sys.argv[i]))
        print("Usage: %s pdfPath epsPath envPath" % sys.argv[0])
        exit(1)

# take in pdf, eps, and venv paths as arguments
pdfPath = sys.argv[1]
epsPath = sys.argv[2]
envPath = sys.argv[3]

# get all PDF files in pdfPath
pdfFiles = glob('{0}/*.pdf'.format(pdfPath))

# activate virtual environment
activate_this = '{0}/bin/activate_this.py'.format(envPath)
execfile(activate_this, dict(__file__=activate_this))
os.chdir('{0}'.format(envPath))

# loop through pdf files and convert to eps
for pdfFile in pdfFiles:
    epsFile = pdfFile[len(pdfPath)+1:-len(".pdf")] + ".eps"
    epsFile = os.path.join(epsPath, epsFile)
    os.system('bin/pdftops -eps "{0}" "{1}"'.format(pdfFile, epsFile))
