<#
.SYNOPSIS
Deploys Azure Bastion for secure RDP/SSH access without public IPs.

.DESCRIPTION
- Creates AzureBastionSubnet
- Deploys Bastion host
#>

param(
    [string]$ResourceGroupName = "rg-tbs-security",
    [string]$VnetName = "vnet-tbs",
    [string]$Location = "westeurope",
    [string]$BastionName = "bastion-tbs"
)

Write-Host "Getting VNet $VnetName..." -ForegroundColor Cyan
$vnet = Get-AzVirtualNetwork -Name $VnetName -ResourceGroupName $ResourceGroupName

Write-Host "Adding AzureBastionSubnet (10.0.2.0/27)..." -ForegroundColor Cyan
Add-AzVirtualNetworkSubnetConfig `
    -Name "AzureBastionSubnet" `
    -AddressPrefix "10.0.2.0/27" `
    -VirtualNetwork $vnet

$vnet | Set-AzVirtualNetwork | Out-Null

Write-Host "Creating Public IP for Bastion..." -ForegroundColor Cyan
$pip = New-AzPublicIpAddress `
    -Name "$BastionName-pip" `
    -ResourceGroupName $ResourceGroupName `
    -Location $Location `
    -AllocationMethod Static `
    -Sku Standard

Write-Host "Deploying Azure Bastion..." -ForegroundColor Cyan
New-AzBastion `
    -Name $BastionName `
    -ResourceGroupName $ResourceGroupName `
    -Location $Location `
    -PublicIpAddress $pip `
    -VirtualNetwork $vnet

Write-Host "Azure Bastion deployed successfully." -ForegroundColor Green
