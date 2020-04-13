# Export all files in an on-prem Sharepoint site regardless of status, keeping directory structure
# Make sure you have the correct Sharepoint admin permissions
# May need to be run under one of the initial Sharepoint install or service admins, or from the server
# 4-13-20 MattC

# -- START CONFIGURATION --
$spSite = "http://localhost/sites/contoso"
$targetDir = "C:\TEMP\Sharepoint_Documents" # target directory for root of exported files and folders
# -- END CONFIGURATION --

# Recursively get all files. Parameter may be overloaded
# Use Push and Pop to keep directory structure in stack
# Use FileStream and BinaryWriter to export files regardless of their status
Function GetFiles($folder) {
	if ($folder -ne $null) {
		$new_path = '.\' + $folder.Name
		Write-Output("** Creating directory $new_path and pushing location...")
		New-Item -Path $new_path -ItemType Directory -ErrorAction SilentlyContinue
		Push-Location $new_path
		ForEach ($file in $folder.files) {
			$path = (Get-Location | Select -ExpandProperty Path) + '\' + $file.Name
			Write-Output ("** Writing $path...")
    			$b = $file.OpenBinary()
    			$fs = New-Object System.IO.FileStream($path, [System.IO.FileMode]::Create)
    			$bw = New-Object System.IO.BinaryWriter($fs)
    			$bw.Write($b)
    			$bw.Close()
		} #end foreach
		ForEach ($subfolder in $folder.subfolders) {
			GetFiles($subfolder) #recurse
		} #end foreach
		Pop-Location
	} #end if
} #end function

# Iterate through all lists and all their folders
Write-Output("** Working with $spSite")
$SPWeb = Get-SPWeb $spSite
ForEach ($list in $SPWeb.lists) {
	ForEach ($folder in $list.RootFolder) {
		If ($folder -ne $null) {	
			Write-Output("** Starting in $targetDir")
			Push-Location $targetDir
			GetFiles($folder)	
			Pop-Location
		} #end if
	} #end foreach
} #end foreach