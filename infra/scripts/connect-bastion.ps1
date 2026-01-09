<#
.SYNOPSIS
Displays Bastion connection details for the VM.

.DESCRIPTION
Shows:
- VM name
- Resource group
- Instructions for connecting via Azure Portal Bastion
#>

param(
    [string]$ResourceGroupName = "rg-tbs-security",
    [string]$VmName = "vm-tbs01"
)

Write-Host "Azure Bastion is ready." -ForegroundColor Green
Write-Host ""
Write-Host "To connect to the VM using Bastion:" -ForegroundColor Cyan
Write-Host "1. Go to Azure Portal" -ForegroundColor Cyan
Write-Host "2. Open VM: $VmName" -ForegroundColor Cyan
Write-Host "3. Select 'Connect' → 'Bastion'" -ForegroundColor Cyan
Write-Host "4. Enter your admin credentials" -ForegroundColor Cyan
Write-Host ""
Write-Host "No public IP is required. Traffic stays inside Azure." -ForegroundColor Green
