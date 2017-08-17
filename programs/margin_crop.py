## Crops the white margins in a pdf file

# import standard modules
import sys
from glob import *
import os

# check that first two arguments are directories
if len(sys.argv)!=4:
    print("Usage: %s inputPath croppedPath envPath" % sys.argv[0])
    exit(1)

for i in range(1,3):
    if not os.path.isdir(sys.argv[i]):
        print('"{0}"" is not a directory'.format(sys.argv[i]))
        print("Usage: %s inputPath croppedPath envPath" % sys.argv[0])
        exit(1)

# take in input, output, and venv directories as arguments
inputPath = sys.argv[1]
croppedPath = sys.argv[2]
envPath = sys.argv[3]

# get all uncropped files in inputPath
inputFiles = glob('{0}/*.pdf'.format(inputPath))

# activate virtual environment
activate_this = '{0}/bin/activate_this.py'.format(envPath)
execfile(activate_this, dict(__file__=activate_this))
os.chdir('{0}'.format(envPath))

# loop through and crop pdf files
for inputFile in inputFiles:
    croppedFile = inputFile[len(inputPath)+1:]
    croppedFile = os.path.join(croppedPath, croppedFile)
    os.system('python bin/pdf-crop-margins -o "{1}" -p 2 "{0}"'.format(inputFile, croppedFile))
