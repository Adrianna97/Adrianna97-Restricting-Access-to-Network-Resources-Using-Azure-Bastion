<#
.SYNOPSIS
Helps verify access to the VM according to NSG rules.

.DESCRIPTION
- Gets public IP of vm-tbs01
- Shows it to the user for RDP testing
- Optionally tries port reachability using Test-NetConnection
#>

param(
    [string]$ResourceGroupName = "rg-tbs-security",
    [string]$VmName = "vm-tbs01"
)

Write-Host "Getting public IP of VM $VmName..." -ForegroundColor Cyan

$nicId = (Get-AzVM -ResourceGroupName $ResourceGroupName -Name $VmName).NetworkProfile.NetworkInterfaces[0].Id
$nic   = Get-AzNetworkInterface -ResourceId $nicId
$pipId = $nic.IpConfigurations[0].PublicIpAddress.Id
$pip   = Get-AzPublicIpAddress -ResourceId $pipId

$publicIp = $pip.IpAddress
Write-Host "Public IP of $VmName: $publicIp" -ForegroundColor Green

Write-Host ""
Write-Host "Now test:" -ForegroundColor Cyan
Write-Host "1. From your trusted network: mstsc -> $publicIp" -ForegroundColor Cyan
Write-Host "2. From an untrusted network: connection should be blocked by NSG." -ForegroundColor Cyan
Write-Host ""

if (Get-Command Test-NetConnection -ErrorAction SilentlyContinue) {
    Write-Host "Testing RDP port (3389) from this machine..." -ForegroundColor Cyan
    Test-NetConnection -ComputerName $publicIp -Port 3389
} else {
    Write-Host "Test-NetConnection is not available in this environment." -ForegroundColor Yellow
}
