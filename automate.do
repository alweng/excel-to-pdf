// Automates processing results into nice tables

********************************************************************************
********************************************************************************

clear all
set more off

***************************************
***			DEFINE SWITCHES 		***
***************************************

local switch_setup 				= 1		// setting up program for first time
local switch_excel_to_pdf		= 0		// convert tables from excel to pdf
local switch_crop_margins		= 1		// crop white margins
local switch_pdf_to_eps			= 1		// convert cropped pdfs into eps files

***************************************
***			DEFINE MACROS 			***
***************************************

// options
local ignore_first_sheet	1	// if set to 1, ignores first sheet of excel file when converting to pdf

// main directories				
local root 					"/Users/`c(username)'/Dropbox (MIT)/automation"
local files					"`root'/files"
local programs				"`root'/programs"
local packages_MacOSX		"`root'/packages/mac"
local packages_Windows		"`root'/packages/windows"

// code	
local setup_MacOSX			"`programs'/setup_packages.sh"
local setup_Windows			"`programs'/setup_packages.ps1"
local excel_pdf_MacOSX		"`programs'/excel_to_pdf.scpt"
local excel_pdf_Windows 	"`programs'/excel_to_pdf.py"
local margin_crop			"`programs'/margin_crop.py"
local pdf_eps				"`programs'/pdf_to_eps.py"
	
// file directories	
local excel_file			"`files'/input/tables_shell.xlsm"
local pdf_path 				"`files'/output_pdf"
local cropped_path			"`files'/output_cropped"
local eps_path				"`files'/output_eps"
	
// virtualenv path	
local venv_path				"`root'/venv"
local vpython_MacOSX		"`venv_path'/bin/python"
local vpython_Windows		"`venv_path'/Scripts/python"

// shell to run
local shell_MacOSX			"bash"
local shell_Windows			"powershell"

***************************************
***		  	  RUN PROGRAMS			***
***************************************

// Set up virtual environment in env_path
// and install necessary packages into the virtual environment
if `switch_setup'{
	shell "`shell_`c(os)''" "`setup_`c(os)''" "`root'" "`packages_`c(os)''"
}

// Refresh the cells in the final workbook to draw off latest estimates
// Export Excel workbook sheets to PDFs
if `switch_excel_to_pdf'{

	if "`c(os)'" == "Windows"{
		shell "`vpython_`c(os)''" "`excel_to_pdf_`c(os)''" "`excel_file'" "`pdf_path'" `ignore_first_sheet'
		}
		
	if "`c(os)'" == "MacOSX"{
		shell "`shell_`c(os)''" osascript "`excel_to_pdf_`c(os)'" "`excel_file'" "`pdf_path'"
		}

}

// Detect and trim white margins off PDF files
if `switch_crop_margins'{
	shell "`vpython_`c(os)''" "`margin_crop'" "`pdf_path'" "`cropped_path'" "`venv_path'"
}
	
// Convert cropped PDF files into EPS format
if `switch_pdf_to_eps'{
	shell "`vpython_`c(os)''" "`pdf_eps'" "`cropped_path'" "`eps_path'" "`venv_path'"
}
