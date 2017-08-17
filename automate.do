// Automates processing results into nice tables

********************************************************************************
********************************************************************************

clear all
set more off

***************************************
***			DEFINE SWITCHES 		***
***************************************

local switch_setup 				= 0		// setting up program for first time
local switch_excel_to_pdf		= 0		// convert tables from excel to pdf
local switch_crop_margins		= 1		// crop white margins
local switch_pdf_to_eps			= 1		// convert cropped pdfs into eps files

***************************************
***			DEFINE MACROS 			***
***************************************

// main directories
local root 				"/Users/`c(username)'/Dropbox (MIT)/automation"
local files				"`root'/files"
local programs			"`root'/programs"
local packages			"`root'/packages"

// code
local setup				"`programs'/setup_packages.sh"
local excel_to_pdf 		"`programs'/excel_to_pdf.py"
local margin_crop		"`programs'/margin_crop.py"
local pdf_eps			"`programs'/pdf_to_eps.py"

// file directories
local excel_file		"`files'/input/tables_shell.xlsm"
local pdf_path 			"`files'/output_pdf"
local cropped_path		"`files'/output_cropped"
local eps_path			"`files'/output_eps"

// virtualenv path
local venv_path			"`root'/venv"
local venv_python		"`venv_path'/bin/python"


***************************************
***		  	  RUN PROGRAMS			***
***************************************

// Set up virtual environment in env_path
// and install necessary packages into the virtual environment
if `switch_setup'{
	shell bash "`setup'" "`root'" "`packages'"
}

// Refresh the cells in the final workbook to draw off latest estimates
// Export Excel workbook sheets to PDFs
if `switch_excel_to_pdf'{
	shell "`venv_python'" "`excel_to_pdf'" "`excel_file'" "`pdf_path'" "`venv_path'"
}

// Detect and trim white margins off PDF files
if `switch_crop_margins'{
	shell "`venv_python'" "`margin_crop'" "`pdf_path'" "`cropped_path'" "`venv_path'"
}
	
// Convert cropped PDF files into EPS format
if `switch_pdf_to_eps'{
	shell "`venv_python'" "`pdf_eps'" "`cropped_path'" "`eps_path'" "`venv_path'"
}
