Write-Host This script requires PowerCLI 6, see notes if you have PowerCLI 5
##If you have PowerCLI 5 use Add-PSSnapin VMware.VimAutomation.Vds -ErrorAction Stop##

#Imports the PowerCLI module
Import-Module VMware.VimAutomation.Vds -ErrorAction Stop

#Setting our vCenter server
$VIServer = "VCENTER.V-BLOG.local"

#Connecting to vCenter and prompts for credentials
Connect-VIServer $VIServer -Credential (Get-Credential) | Out-Null

#Connects to vCenter and gathers various stats 
$VmInfo = ForEach ($Datacenter in (Get-Datacenter | Sort-Object -Property Name)) {
  ForEach ($Cluster in ($Datacenter | Get-Cluster | Sort-Object -Property Name)) {
    ForEach ($VM in ($Cluster | Get-VM | Sort-Object -Property Name)) {
      ForEach ($HardDisk in ($VM | Get-HardDisk | Sort-Object -Property Name)) {
        "" | Select-Object -Property @{N="VM";E={$VM.Name}},
        @{N="VM CPU#";E={$vm.ExtensionData.Config.Hardware.NumCPU/$vm.ExtensionData.Config.Hardware.NumCoresPerSocket}},
        @{N="VM CPU Core#";E={$vm.NumCPU}},
        @{N="Datacenter";E={$Datacenter.name}},
        @{N="Cluster";E={$Cluster.Name}},
        @{N="Host";E={$vm.VMHost.Name}},
        @{N="Host CPU#";E={$vm.VMHost.ExtensionData.Summary.Hardware.NumCpuPkgs}},
        @{N="Host CPU Core#";E={$vm.VMHost.ExtensionData.Summary.Hardware.NumCpuCores/$vm.VMHost.ExtensionData.Summary.Hardware.NumCpuPkgs}},
        @{N="Hard Disk";E={$HardDisk.Name}},
        @{N="Datastore";E={$HardDisk.FileName.Split("]")[0].TrimStart("[")}},
        @{N="VMDKpath";E={$HardDisk.FileName}},
        @{N="Drive Size";E={$HardDisk.CapacityGB}},
        @{N="Memory GB";E={$vm.MemoryGB}}
      }
    }
  }
}

#Exports the VM information to a CSV
$VmInfo | Export-Csv -NoTypeInformation -UseCulture -Path "c:\temp\VMreport.csv"

