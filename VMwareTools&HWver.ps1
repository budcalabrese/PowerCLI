Write-Host This script requires PowerCLI 6, see notes if you have PowerCLI 5
##If you have PowerCLI 5 use Add-PSSnapin VMware.VimAutomation.Vds -ErrorAction Stop##

#Imports the PowerCLI module
Import-Module VMware.VimAutomation.Vds -ErrorAction Stop

#Setting our variables
$VIServer = "YOUR vCenter"
$vm = "YOUR VM"

#Connecting to vCenter and prompts for credentials
Connect-VIServer $VIServer -Credential (Get-Credential) -WarningAction SilentlyContinue 

#Updating VMware Tools without rebooting
Write-host "****** VMware Tools Upgrade ******" -foregroundcolor green
Get-VM $vm | Update-Tools –NoReboot

#Shutting down VM 
Write-host "****** Shutting down VM ******" -foregroundcolor green
Get-VM $vm | Stop-VMGuest -confirm:$false
Start-Sleep -Seconds 60

#Upgrading VM HW Version and setting memory size
Write-host "****** Upgrading Hardware Version and Memory ******" -foregroundcolor green
Set-VM -VM $vm -Version v10 -MemoryGB 32 -confirm:$false

#Powering on VM
Write-host "****** Powering on VM ******" -foregroundcolor green
Start-VM -VM $vm