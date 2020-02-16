# If TPM is not ready, enable it in BIOS using WMI
# Normally requires a reboot to take effect
# Created: 2-7-20 MattC
# Last Updated: 2-7-20 MattC

$bShowOutput = $False

# Check to see if TPM is not ready/initialized
$Tpm = Get-TPM
If ( $Tpm -and $Tpm.TpmPresent ) {
	If ( $Tpm.TpmReady -ne $True ) {
		# Check which model namespace we should use for querying BIOS
		$Namespaces = gwmi -class __Namespace -namespace root | Select -ExpandProperty name

		If ( $Namespaces -contains 'HP' ) {
			# HP BIOS Code
			if ( $bShowOutput ) { Write-Output( 'Using HP settings...' ) }
			$Interface = gwmi -Class HP_BIOSSettingInterface -Namespace root\HP\InstrumentedBIOS 
			$Interface.SetBIOSSetting('TPM Activation Policy', 'No prompts')
			$Interface.SetBIOSSetting('TPM State', 'Enable')
		} ElseIf ( $Namespaces -contains 'Dell' ) {
			# Dell BIOS Code
			if ( $bShowOutput ) { Write-Output( 'Using Dell settings (not implemented yet, does nothing)...' ) }
		} ElseIf ( $Namespaces -contains 'Lenovo' ) {
			# Lenovo BIOS code
			if ( $bShowOutput ) { Write-Output( 'Using Lenovo settings...' ) }
			
			#enable TPM - Lenovo laptops
			(gwmi -class Lenovo_SetBiosSetting –namespace root\wmi).SetBiosSetting('SecurityChip,Active')

			#save settings
			(gwmi -class Lenovo_SaveBiosSettings -namespace root\wmi).SaveBiosSettings()
		} Else {
			if ( $bShowOutput ) { Write-Error( 'Laptop manufacturer not found in WMI namespaces. Aborting.' ) }
		} #end if
	} ElseIf ( $bShowOutput ) {
		Write-Output( 'TPM already ready. Exiting.' )
	} #end if
} Else {
	Write-Warning( 'TPM not present. Exiting.' )
} #end if
