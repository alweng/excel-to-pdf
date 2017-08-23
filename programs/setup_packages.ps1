
Param(
	[Parameter(Mandatory=$True,Position=1)]
	[string]$env_path,
	
	[Parameter(Mandatory=$True, Position=2)]
	[string]$package_path
)

# Install virtualenv (only package installed globally)
Set-Location "$package_path"
TarTool\TarTool.exe virtualenv-15.1.0.tar.gz
Set-Location virtualenv-15.1.0
python setup.py install
Set-Location "$package_path"
Remove-Item -Recurse virtualenv-15.1.0

# Create virtual environment for automation
Set-Location "$env_path"
virtualenv venv
venv\Scripts\activate

# Install python packages
pip install "$package_path\olefile-0.44.zip"
pip install "$package_path\Pillow-4.2.1-cp27-cp27m-win_amd64.whl"
pip install "$package_path\PyPDF2-1.26.0.tar.gz"
pip install "$package_path\pdfCropMargins-0.1.3.tar.gz"
pip install "$package_path\pypiwin32-219-cp27-none-win_amd64.whl"

# Install xpdf
Set-Location "$package_path"
TarTool\TarTool.exe xpdfbin-win-3.04.tar.gz
Copy-Item 	"$package_path\xpdfbin-win-3.04\bin64\*" "venv\Scripts"
Remove-Item -Recurse xpdfbin-win-3.04.tar.gz
