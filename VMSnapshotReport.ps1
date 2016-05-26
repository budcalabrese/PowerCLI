Write-Host This script requires PowerCLI 6, see notes if you have PowerCLI 5
##If you have PowerCLI 5 use Add-PSSnapin VMware.VimAutomation.Vds -ErrorAction Stop##

# Imports the PowerCLI module
Import-Module VMware.VimAutomation.Vds -ErrorAction Stop

# Setting our vCenter server
$VIServer = "VCENTER.V-BLOG.local"

# Connecting to vCenter and prompts for credentials
Connect-VIServer $VIServer -Credential (Get-Credential) | Out-Null

# Used to create our HTML output table with CSS
$Head = @"
<style>
body { background-color:#f6f6f6; font-family:calibri; margin:0px;}
TABLE {border-width: 1px;border-style: solid;border-color: black;border-collapse: collapse;}
TH {border-width: 1px;padding: 3px;border-style: solid;border-color: black;background-color: #34495e; color:#ffffff}
TD {border-width: 1px;padding: 3px;border-style: solid;border-color: black;}
TR:Nth-Child(Even) {Background-Color: #dddddd;}
</style>
"@

# Checks to see if there are any snapshots
# If no snapshots the script will generate a report saying no snapshots
# Else it will generate a report showing the snapshots
$Report = Get-VM | Get-Snapshot | Select VM,Name,Description,@{Label="Size";Expression={"{0:N2} GB" -f ($_.SizeGB)}},Created
If (-not $Report)
{  $Report = New-Object PSObject -Property @{
      VM = "No snapshots found on any VM's controlled by $VIServer"
      Name = ""
      Description = ""
      Size = ""
      Created = ""
   }
}
$Report | ConvertTo-Html -Head $Head -PreContent "<p><h2> Snapshot Report - $VIServer </h2></p><br>" | Out-File "C:\temp\SnapshotReport.html"
