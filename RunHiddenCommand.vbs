' Run the given command in a hidden window
' Used with local Scheduled Tasks to make sure no window pops up
' Make sure to give the //NoLogo parameter to cscript.exe
' 2-21-20 MattC
if WScript.Arguments.Count > 0 then
	Dim WinScriptHost
	Set WinScriptHost = CreateObject("WScript.Shell")
	WinScriptHost.Run Chr(34) & Wscript.Arguments(0) & Chr(34), 0
	Set WinScriptHost = Nothing
end if