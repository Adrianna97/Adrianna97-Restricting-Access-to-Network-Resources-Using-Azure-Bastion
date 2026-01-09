<#
.SYNOPSIS
Creates resource group, virtual network, subnet, NSG and Windows VM for TBS project.

.DESCRIPTION
This script automates creation of:
- Resource group: rg-tbs-security
- VNet: vnet-tbs (10.0.0.0/16)
- Subnet: subnet-vm (10.0.1.0/24)
- NSG: nsg-tbs01
- Public IP (for initial testing only)
- NIC with NSG
- Windows Server 2019 VM: vm-tbs01
#>

param(
    [string]$Location = "westeurope",
    [string]$AdminUsername = "tbsadmin",
    [Parameter(Mandatory = $true)]
    [securestring]$AdminPassword
)

$rgName      = "rg-tbs-security"
$vnetName    = "vnet-tbs"
$subnetName  = "subnet-vm"
$nsgName     = "nsg-tbs01"
$vmName      = "vm-tbs01"
$ipName      = "pip-tbs01"
$nicName     = "nic-tbs01"

Write-Host "Creating resource group $rgName..." -ForegroundColor Cyan
New-AzResourceGroup -Name $rgName -Location $Location -ErrorAction Stop

Write-Host "Creating virtual network $vnetName and subnet $subnetName..." -ForegroundColor Cyan
$subnetConfig = New-AzVirtualNetworkSubnetConfig -Name $subnetName -AddressPrefix "10.0.1.0/24"

New-AzVirtualNetwork `
    -Name $vnetName `
    -ResourceGroupName $rgName `
    -Location $Location `
    -AddressPrefix "10.0.0.0/16" `
    -Subnet $subnetConfig `
    -ErrorAction Stop

Write-Host "Creating Network Security Group $nsgName..." -ForegroundColor Cyan
$nsg = New-AzNetworkSecurityGroup `
    -ResourceGroupName $rgName `
    -Location $Location `
    -Name $nsgName `
    -ErrorAction Stop

Write-Host "Creating public IP for initial testing..." -ForegroundColor Cyan
$pip = New-AzPublicIpAddress `
    -Name $ipName `
    -ResourceGroupName $rgName `
    -Location $Location `
    -AllocationMethod Static `
    -Sku Standard `
    -ErrorAction Stop

Write-Host "Getting subnet and creating NIC..." -ForegroundColor Cyan
$vnet   = Get-AzVirtualNetwork -Name $vnetName -ResourceGroupName $rgName
$subnet = Get-AzVirtualNetworkSubnetConfig -Name $subnetName -VirtualNetwork $vnet

$nic = New-AzNetworkInterface `
    -Name $nicName `
    -ResourceGroupName $rgName `
    -Location $Location `
    -Subnet $subnet `
    -PublicIpAddress $pip `
    -NetworkSecurityGroup $nsg `
    -ErrorAction Stop

Write-Host "Creating Windows Server VM $vmName..." -ForegroundColor Cyan
$vmConfig = New-AzVMConfig -VMName $vmName -VMSize "Standard_B2s" |
    Set-AzVMOperatingSystem -Windows -ComputerName $vmName -Credential (New-Object System.Management.Automation.PSCredential($AdminUsername, $AdminPassword)) -ProvisionVMAgent -EnableAutoUpdate |
    Set-AzVMSourceImage -PublisherName "MicrosoftWindowsServer" -Offer "WindowsServer" -Skus "2019-Datacenter" -Version "latest" |
    Add-AzVMNetworkInterface -Id $nic.Id

New-AzVM -ResourceGroupName $rgName -Location $Location -VM $vmConfig -ErrorAction Stop

Write-Host "VM $vmName created successfully." -ForegroundColor Green
