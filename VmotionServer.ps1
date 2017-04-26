# Setting the variables 
$vCenter = 'vCenterServer'
$username = 'username'
$pwdTxt = Get-Content "C:\temp\ExportedPassword.txt"
$securePwd = $pwdTxt | ConvertTo-SecureString 
$credObject = New-Object System.Management.Automation.PSCredential -ArgumentList $username, $securePwd
$targethost = 'esxihostname'
$serverlist = Get-Content "C:\temp\list.csv"

# Importing the PowerCLI Module
Import-Module VMware.VimAutomation.Vds -ErrorAction Stop

# Connecting to vCenter
Write-Host "Connecting to $vCenter..."
Connect-VIServer -Server $vCenter -Cred $credObject -ErrorAction SilentlyContinue

# Moving VM's in the server list variable
ForEach ($server in $serverlist) {
    Try {
        Get-VM $server | Move-VM -Destination $targethost
        Write-Output "Moved $server to $targethost" | Out-File "C:\temp\vmotion.csv" -Append
    }    
    Catch {
        Write-Output "Error moving $server to $targethost" | Out-File "C:\temp\vmotionerror.csv" -Append
    }
}
