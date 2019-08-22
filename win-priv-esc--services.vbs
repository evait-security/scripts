strComputer = "."
outfile="report.txt"
servicecount=0
on error resume next
Dim objFSO, objFile

Set objFSO =CreateObject("Scripting.FileSystemObject")
Set shell = CreateObject("Wscript.Shell")
Set objWMIService = GetObject("winmgmts:\\" & strComputer & "\root\CIMV2")
Set colItems = objWMIService.ExecQuery( _
    "SELECT * FROM Win32_Service",,48)
For Each objItem in colItems
    If objItem.State = "Stopped" then
    	str1 = lcase(Replace(objItem.PathName, Chr(34), ""))
    	pos = InStr(1,str1, ".exe")
    	pos = pos + 4
    	str2 = Left(str1, pos)

    	On Error Resume Next
    	Set f = objFSO.OpenTextFile(str2,8)
    	If Err.Number <> 0 Then
			f.Close
    	Else
			servicecount= servicecount + 1
			f.Close
    		Set fsout = objFSO.OpenTextFile(outfile,8,true)
    		fsout.Write("----------------------------------------" & vbCrLf)
			  fsout.Write("# Name: " & objItem.DisplayName & vbCrLf)
			  fsout.Write("# Service-Name: " & objItem.Name & vbCrLf)
    		fsout.Write("# EXE: " & objItem.PathName & vbCrLf)
    		fsout.Write("# StartMode: " & objItem.StartMode & vbCrLf)
    		fsout.Write("# StartName: " & objItem.StartName & vbCrLf)
    		fsout.Write("# State: " & objItem.State & vbCrLf)
    		fsout.Write("----------------------------------------" & vbCrLf)
    		fsout.Close
    	End If
     	Set objFile = nothing
	    set f = nothing
    End If
Next

If servicecount = 0 Then
    Set fsout = objFSO.OpenTextFile(outfile,8,true)
    fsout.Write("No Vulnerable Services found." & vbCrLf)
    fsout.Close
End If
