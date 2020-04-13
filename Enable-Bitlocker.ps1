# Check domain is reachable, force GP refresh (for Bitlocker settings), and enable BitLocker
# Can be run as a startup or logon script by commenting out Invoke-GPUpdate
# Last Updated: 2-19-20 MattC

# Check if machine is joined to a domain and current domain is reachable, in case of cached group policy
$domain = (Get-WmiObject Win32_ComputerSystem -ErrorAction Stop).Domain
If ( $domain -And (New-Object System.Net.Sockets.TCPClient -ArgumentList $domain,389) ) {
	# Refresh Group Policy to make sure it gets the necessary Bitlocker group policy
	# Group policy in various domain entities set to backup Bitlocker keys to AD
	# NOTE: Comment out the line below if you're using it as a startup or logon script deployed through GP
	Invoke-GPUpdate -Force -ErrorAction Stop

	# Check current protection status and only enable if not already enabled
	$pStatus = Get-BitlockerVolume $env:SystemDrive -ErrorAction Stop | Select -ExpandProperty ProtectionStatus
	If ( ! $pStatus ) {
        #Write-Output('Protection is off')
		# Not necessarily required to add TPM protector, but add it explicitly anyway
		Add-BitLockerKeyProtector -MountPoint $env:SystemDrive -TpmProtector
		Enable-Bitlocker -MountPoint $env:SystemDrive -RecoveryPasswordProtector -SkipHardwareTest
	} #end if
} #end if
