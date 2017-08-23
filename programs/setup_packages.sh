#!/bin/bash

package_path=$2
env_path=$1

# Install virtualenv (only package installed globally)
cd "$package_path"
tar xvfz virtualenv-15.1.0.tar.gz
cd virtualenv-15.1.0
python virtualenv.py install
cd "$package_path"
rm -r virtualenv-15.1.0

# Create virtual environment for automation
cd "$env_path"
/usr/local/bin/virtualenv venv
source venv/bin/activate

# Install python packages
python venv/bin/pip install "$package_path/olefile-0.44.zip"
python venv/bin/pip install "$package_path/Pillow-4.2.1-cp27-cp27m-macosx_10_6_intel.macosx_10_9_intel.macosx_10_9_x86_64.macosx_10_10_intel.macosx_10_10_x86_64.whl"
python venv/bin/pip install "$package_path/PyPDF2-1.26.0.tar.gz"
python venv/bin/pip install "$package_path/pdfCropMargins-0.1.3.tar.gz"

# Install xpdf
cd "$package_path"
tar -zxvf "$package_path/xpdfbin-mac-3.04.tar.gz"
mkdir -p "$env_path/venv/man/man1"
mkdir -p "$env_path/venv/man/man5"
mkdir -p "$env_path/venv/etc/xpdfrc"
cp "$package_path/xpdfbin-mac-3.04/bin64"/* "venv/bin"
cp "$package_path/xpdfbin-mac-3.04/doc"/*.1 "venv/man/man1"
cp "$package_path/xpdfbin-mac-3.04/doc"/*.5 "venv/man/man5"
cp "$package_path/xpdfbin-mac-3.04/doc/sample-xpdfrc" "venv/etc/xpdfrc"
rm -r "$package_path/xpdfbin-mac-3.04"

# Fix bug in pdfCropMargins
buggy_file="$(find "$env_path" -name external_program_calls.py)"
sed -i.bak "s/ignore_called_process_errors = False/ignore_called_process_errors = True # pdftoppm returns code 99 but works/g" "$buggy_file"
rm "$buggy_file.bak"
