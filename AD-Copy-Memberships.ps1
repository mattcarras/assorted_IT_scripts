# Copy memberships from one domain user to another
# Uses VisualBasic InputBox
# Last Updated: 10-17-19 MattC

# Load VB assembly for InputBox
[void][Reflection.Assembly]::LoadWithPartialName('Microsoft.VisualBasic')
$sTitle = 'Enter user to copy FROM'
$sMsg = 'User to copy FROM: '
$sUserIDSrc = [Microsoft.VisualBasic.Interaction]::InputBox($sMsg, $sTitle)
Try {
	$oCopyFromUser = Get-ADUser $sUserIDSrc -prop MemberOf
	
	$sTitle = 'Enter user to copy TO'
	$sMsg = 'User to copy TO: '
	$sUserIDDest = [Microsoft.VisualBasic.Interaction]::InputBox($sMsg, $sTitle)
	Try {
		$oCopyToUser = Get-ADUser $sUserIDDest -prop MemberOf
		Try {
			$oCopyFromUser.MemberOf | Add-ADGroupMember -Members $oCopyToUser
			Write-Output ("-- Resulting Group Memberships for {0} --" -f $sUserIDDest)
			Get-ADUser $sUserIDDest -prop MemberOf | Select-Object -ExpandProperty MemberOf | ft
		} Catch {
			Write-Output ("* ERROR - Error adding memberships.")
		} # end try/catch
	} Catch {
		Write-Output ("* ERROR - Invalid destination user. Aborting.")
	} # end try/catch
} Catch {
	Write-Output ("* ERROR - Invalid source user. Aborting.")
} # end try/catch

Write-Output ("* Done. Press any key to continue...")
$HOST.UI.RawUI.ReadKey("NoEcho,IncludeKeyDown") | OUT-NULL
$HOST.UI.RawUI.Flushinputbuffer()