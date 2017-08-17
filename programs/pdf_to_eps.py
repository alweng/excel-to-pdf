## Converts all PDF files in the directory pdfPath 
## to eps files in the directory epsPath

# import standard modules
import sys
from glob import *
import os

# check that first two arguments are directories
if len(sys.argv)!=4:
    print("Usage: %s pdfPath epsPath envPath" % sys.argv[0])
    exit(1)

for i in range(1,3):
    if not os.path.isdir(sys.argv[i]):
        print('"{0}" is not a file path'.format(sys.argv[i]))
        print("Usage: %s pdfPath epsPath envPath" % sys.argv[0])
        exit(1)

# take in pdf, eps, and venv paths as arguments
pdfPath = os.path.normpath(sys.argv[1])
epsPath = os.path.normpath(sys.argv[2])
envPath = os.path.normpath(sys.argv[3])

# get all PDF files in pdfPath
pdfFiles = glob('{0}/*.pdf'.format(pdfPath))

# activate virtual environment
if sys.platform == "darwin":
    activate_this = os.path.join(envPath, 'bin', 'activate_this.py')
elif sys.platform == "win32":
    activate_this = os.path.join(envPath, 'Scripts', 'activate_this.py')
execfile(activate_this, dict(__file__=activate_this))
os.chdir('{0}'.format(envPath))

# loop through pdf files and convert to eps
for pdfFile in pdfFiles:
    epsFile = pdfFile[len(pdfPath)+1:-len(".pdf")] + ".eps"
    epsFile = os.path.join(epsPath, epsFile)

	# call pdftops from command line
    if sys.platform == "darwin":
        os.system('bin/pdftops -eps "{0}" "{1}"'.format(pdfFile, epsFile))
    elif sys.platform == "win32":
        os.system('pdftops -eps "{0}" "{1}"'.format(pdfFile, epsFile))
