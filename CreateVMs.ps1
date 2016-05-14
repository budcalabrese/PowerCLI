######Creates Virtual Machine from a CSV######

#Establishing connection to vCenter
Connect-VIServer VCENTER-01.V-Blog.local

#Imports variables from CSV for VM creation
#CSV needs Name, Template, DestinationHost, Datastore, CustomSpec, NumCpu, MemoryMB

$VirtualMachineCSV = "C:\temp\VMTemplate.csv"

#Uses the variables from the CSV to create the Virtual Machines

$VirtualMachine = Import-CSV $VirtualMachineCSV
$VirtualMachine | %{ New-VM -Name $_.Name -Template $(Get-Template  $_.Template) -VMHost $(Get-VMHost $_.DestinationHost) -Datastore$(Get-Datastore $_.Datastore) -OSCustomizationSpec $(Get-OSCustomizationSpec $_.CustomSpec) }
$VirtualMachine | %{ Set-VM -VM $_.Name -NumCpu $_.NumCpu -MemoryMB $_.MemoryMB -Confirm:$false }
$VirtualMachine | %{ Start-VM -VM $_.Name -Confirm:$false }
