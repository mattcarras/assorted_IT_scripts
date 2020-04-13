# Assorted IT Scripts
 Various IT scripts. **See comment headers for additional details on each script.**
 
**Enable-TPM.ps1**: Powershell script to enable the TPM option in a machine's BIOS / UEFI. Tested on HP and Lenovo laptops.

**Enable-Bitlocker.ps1**: Powershell script to enable Bitlocker with TPM and RecoveryPassword protectors, intended to then be backed up to AD by a Group Policy setting. Can be deployed through GPO as a startup script if one comments out the "Invoke-GPUpdate" line.

**Sharepoint-ExportFiles.ps1**: Powershell script to export files regardless of current status from the given Sharepoint site to the given target directory, keeping the directory structure intact. May need to be run from the Sharepoint server itself.

**AD-Copy-Memberships.ps1**: Powershell script to copy all memberships from one given AD user to another.

**RunHiddenCommand.vbs**: Visual Basic script to attempt to run a given command without showing a window, intended for scheduled tasks run in the user context. Tested with the //NOLOGO switch given to cscript.exe.


 
