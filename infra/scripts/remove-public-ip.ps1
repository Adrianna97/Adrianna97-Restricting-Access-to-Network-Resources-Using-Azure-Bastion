<#
.SYNOPSIS
Removes the public IP from the VM NIC to prepare for Azure Bastion.

.DESCRIPTION
- Detaches Public IP from NIC
- Deletes Public IP resource
- Ensures VM is no longer exposed to the Internet
#>

param(
    [string]$ResourceGroupName = "rg-tbs-security",
    [string]$VmName = "vm-tbs01"
)

Write-Host "Getting VM $VmName..." -ForegroundColor Cyan
$vm = Get-AzVM -ResourceGroupName $ResourceGroupName -Name $VmName

$nicId = $vm.NetworkProfile.NetworkInterfaces[0].Id
$nic = Get-AzNetworkInterface -ResourceId $nicId

$pipId = $nic.IpConfigurations[0].PublicIpAddress.Id
$pip = Get-AzPublicIpAddress -ResourceId $pipId

Write-Host "Removing Public IP from NIC..." -ForegroundColor Cyan
$nic.IpConfigurations[0].PublicIpAddress = $null
$nic | Set-AzNetworkInterface | Out-Null

Write-Host "Deleting Public IP resource..." -ForegroundColor Cyan
Remove-AzPublicIpAddress -ResourceGroupName $ResourceGroupName -Name $pip.Name -Force

Write-Host "Public IP removed successfully. VM is no longer exposed to the Internet." -ForegroundColor Green
