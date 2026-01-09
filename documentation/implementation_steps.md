# Implementation Steps — Detailed Guide

## Step 1 — Create Virtual Network and Subnet
- Created VNet: vnet-tbs
- Address space: 10.0.0.0/16
- Created subnet: subnet-vm (10.0.1.0/24)

## Step 2 — Deploy Windows Server VM
- VM name: vm-tbs01
- Image: Windows Server 2019 Datacenter
- Resource group: rg-tbs-security
- Assigned to vnet-tbs and subnet-vm
- Created public IP for testing
- Created NSG: nsg-tbs01

## Step 3 — Configure NSG Rules
Default NSG rules allowed too much inbound traffic.

Actions taken:
- Removed “Allow RDP from Any”
- Added rule:
  - Source: My IP
  - Port: 3389
  - Priority: 100
  - Action: Allow
  - Name: Allow-RDP-Trusted
- Added rule for future web access:
  - Source: My IP
  - Port: 80
  - Priority: 200
  - Action: Allow
  - Name: Allow-HTTP-Trusted

## Step 4 — Access Testing
- Verified RDP access from trusted IP
- Verified blocked access from untrusted IP
- Checked NSG Flow Logs for rejected traffic

## Step 5 — Future Hardening
- Planned deployment of Azure Bastion to eliminate public IP exposure

