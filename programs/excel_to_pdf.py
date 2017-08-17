from win32com import client
import win32api

def exceltopdf(doc):
    excel = client.DispatchEx("Excel.Application")
    excel.Visible = 0

    wb = excel.Workbooks.Open(doc)
    ws = wb.Worksheets[1]

    try:
        wb.SaveAs('c:\\targetfolder\\result.pdf', FileFormat=57)
    except Exception, e:
        print "Failed to convert"
        print str(e)
    finally:
        wb.Close()
        excel.Quit()