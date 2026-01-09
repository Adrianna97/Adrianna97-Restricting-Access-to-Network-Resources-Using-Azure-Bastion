<#
.SYNOPSIS
Configures NSG rules for TBS project (trusted IP only).

.DESCRIPTION
- Removes default wide RDP allow rule if present
- Adds:
  - Allow-RDP-Trusted: My IP -> 3389
  - Allow-HTTP-Trusted: My IP -> 80
#>

param(
    [string]$ResourceGroupName = "rg-tbs-security",
    [string]$NsgName = "nsg-tbs01",
    [Parameter(Mandatory = $true)]
    [string]$TrustedIp
)

Write-Host "Getting NSG $NsgName in resource group $ResourceGroupName..." -ForegroundColor Cyan
$nsg = Get-AzNetworkSecurityGroup -Name $NsgName -ResourceGroupName $ResourceGroupName -ErrorAction Stop

# Remove default wide RDP rule if exists
$defaultRdpRule = $nsg.SecurityRules | Where-Object { $_.Name -match "RDP" -and $_.SourceAddressPrefix -eq "*" }
if ($defaultRdpRule) {
    Write-Host "Removing default wide RDP rule: $($defaultRdpRule.Name)..." -ForegroundColor Yellow
    $nsg.SecurityRules.Remove($defaultRdpRule) | Out-Null
}

Write-Host "Adding Allow-RDP-Trusted rule (3389 from $TrustedIp)..." -ForegroundColor Cyan
$ruleRdp = New-AzNetworkSecurityRuleConfig `
    -Name "Allow-RDP-Trusted" `
    -Description "Allow RDP from trusted IP only" `
    -Access Allow `
    -Protocol Tcp `
    -Direction Inbound `
    -Priority 100 `
    -SourceAddressPrefix $TrustedIp `
    -SourcePortRange * `
    -DestinationAddressPrefix * `
    -DestinationPortRange 3389

Write-Host "Adding Allow-HTTP-Trusted rule (80 from $TrustedIp)..." -ForegroundColor Cyan
$ruleHttp = New-AzNetworkSecurityRuleConfig `
    -Name "Allow-HTTP-Trusted" `
    -Description "Allow HTTP from trusted IP only" `
    -Access Allow `
    -Protocol Tcp `
    -Direction Inbound `
    -Priority 200 `
    -SourceAddressPrefix $TrustedIp `
    -SourcePortRange * `
    -DestinationAddressPrefix * `
    -DestinationPortRange 80

# Remove existing rules with same names if they exist
$nsg.SecurityRules = $nsg.SecurityRules | Where-Object { $_.Name -ne "Allow-RDP-Trusted" -and $_.Name -ne "Allow-HTTP-Trusted" }

# Add new ones
$nsg.SecurityRules.Add($ruleRdp)  | Out-Null
$nsg.SecurityRules.Add($ruleHttp) | Out-Null

Write-Host "Updating NSG..." -ForegroundColor Cyan
$nsg | Set-AzNetworkSecurityGroup | Out-Null

Write-Host "NSG configuration updated successfully." -ForegroundColor Green

