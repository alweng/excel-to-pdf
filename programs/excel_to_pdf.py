## This script exports each sheet in an
## excel workbook to a separate PDF file

# import module to work with Excel
from win32com import client
import win32api
import os
import sys

# arguments for excel file and output path
excelFile = os.path.normpath(sys.argv[1])
pdfPath = os.path.normpath(sys.argv[2])

# optional argument for sheet indices (starting from 0) to ignore
if len(sys.argv) > 3:
	if sys.argv[3]: ignoreSheets = [0]

# create Excel object and open workbook
objExcel = client.DispatchEx("Excel.Application")
objExcel.Visible = False
workbook = objExcel.Workbooks.Open(excelFile, 3)
workbook.saved = True

# refresh workbook
workbook.RefreshAll()

# loop through sheets, ignoring any specified in ignoreSheets
for index in range(workbook.Sheets.Count):
	if index not in ignoreSheets:
	
		sheet = workbook.Worksheets[index]
				
		# create path for pdf
		filePath = os.path.join(pdfPath, '{0}.pdf'.format(sheet.Name))
			
		# ignore empty worksheets
		if sheet.UsedRange.Columns.Count == 1 & sheet.UsedRange.Rows.Count == 1:
			print('sheet {0} is empty; could not save to pdf'.format(sheet.Name))
			
		# export as pdf
		else:
			try:
				sheet.ExportAsFixedFormat(0, filePath)
				print('saving {0}.pdf'.format(sheet.Name))
			except:
				print('could not convert sheet "{0}"'.format(sheet.Name))
			
# close Excel
objExcel.Workbooks.Close()
objExcel.Quit()
