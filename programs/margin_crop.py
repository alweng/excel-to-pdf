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
inputPath = os.path.normpath(sys.argv[1])
croppedPath = os.path.normpath(sys.argv[2])
envPath = os.path.normpath(sys.argv[3])

# get all uncropped files in inputPath
inputFiles = glob('{0}/*.pdf'.format(inputPath))

# activate virtual environment
if sys.platform == "darwin":
    activate_this = os.path.join(envPath, 'bin', 'activate_this.py')
elif sys.platform == "win32":
    activate_this = os.path.join(envPath, 'Scripts', 'activate_this.py')
execfile(activate_this, dict(__file__=activate_this))
os.chdir('{0}'.format(envPath))

# loop through and crop pdf files
for inputFile in inputFiles:
    croppedFile = inputFile[len(inputPath)+1:]
    croppedFile = os.path.join(croppedPath, croppedFile)
    
	# call pdf-crop-margins from command line
    if sys.platform == "darwin":
        os.system('python bin/pdf-crop-margins -o "{1}" -p 2 "{0}"'.format(inputFile, croppedFile))
    elif sys.platform == "win32":
        os.system('pdf-crop-margins -o "{1}" -p 2 -pdl "{0}"'.format(inputFile, croppedFile))
