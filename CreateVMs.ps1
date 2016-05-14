#Creates Virtual Machine from a CSV
#CSV needs Name, Template, DestinationHost, CustomSpec, NumCpu, MemoryMB

#Declaring variables to connect to vCenter
$vCenter_Server = "192.168.1.18"

#Establishing connection to vCenter
Connect-VIServer -Server $vCenter_Server

#Imports variables from CSV for VM creation
#CSV must include Name, Template, DestinationHost, CustomSpec, NumCpu, MemoryMB

$VirtualMachineCSV = "C:\temp\VMTemplate.csv"

$VirtualMachine = Import-CSV $VirtualMachineCSV
$VirtualMachine | %{ New-VM -Name $_.Name -Template $(Get-Template  $_.Template) -VMHost $(Get-VMHost $_.DestinationHost) -Datastore$(Get-Datastore $_.Datastore) -OSCustomizationSpec $(Get-OSCustomizationSpec $_.CustomSpec) }
$VirtualMachine | %{ Set-VM -VM $_.Name -NumCpu $_.NumCpu -MemoryMB $_.MemoryMB -Confirm:$false }
$VirtualMachine | %{ Start-VM -VM $_.Name -Confirm:$false }
