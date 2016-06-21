Write-Host This script requires PowerCLI 6, see notes if you have PowerCLI 5
##If you have PowerCLI 5 use Add-PSSnapin VMware.VimAutomation.Vds -ErrorAction Stop##

#Imports the PowerCLI module
Import-Module VMware.VimAutomation.Vds -ErrorAction Stop

#Setting our vCenter server
$VIServer = "VCENTER.V-BLOG.local"

#Connecting to vCenter and prompts for credentials
Connect-VIServer $VIServer -Credential (Get-Credential) | Out-Null

#Connects to vCenter and gathers various stats 
&{foreach($vm in (Get-VM)) { 
    $vm.ExtensionData.Guest.Net |
    select -Property @{N='VM';E={$vm.Name}}, 
      @{N='Host';E={$vm.VMHost.Name}}, 
      @{N='OS';E={$vm.Guest.OSFullName}}, 
      @{N='Tools';E={$vm.ExtensionData.Guest.ToolsRunningStatus}}, 
     @{N='NicType';E={[string]::Join(',',(Get-NetworkAdapter -Vm $vm | Select-Object -ExpandProperty Type))}}, 
      @{N='VLAN';E={[string]::Join(',',(Get-NetworkAdapter -Vm $vm | Select-Object -ExpandProperty NetworkName))}}, 
      @{N='IP';E={[string]::Join(',',($vm.Guest.IPAddress | Where {($_.Split(".")).length -eq 4}))}}, 
      @{N='Gateway';E={[string]::Join(',',(
                $vm.ExtensionData.Guest.IpStack.IpRouteConfig.IpRoute |%{
                if($_.Gateway.IpAddress){
                  $_.Gateway.IpAddress
                }}))}}, 
      @{N='Subnet Mask';E={ 
                $dec = [Convert]::ToUInt32($(('1' * $_.IpConfig.IpAddress[0].PrefixLength).PadRight(32, '0')), 2) 
                $DottedIP = $( For ($i = 3; $i -gt -1; $i--) { 
                        $Remainder = $dec % [Math]::Pow(256, $i) 
                        ($dec - $Remainder) / [Math]::Pow(256, $i) 
                        $dec = $Remainder 
                    }) 
                [String]::Join('.', $DottedIP)  
            }}, 
      @{N="DNS";E={[string]::Join(',',($vm.ExtensionData.Guest.IpStack.DnsConfig.IpAddress))}}, 
     @{N='MAC';E={[string]::Join(',',$_.MacAddress)}} 
}} | Export-Csv -NoTypeInformation -Path "C:\temp\NetworkInfo.csv" -UseCulture 


