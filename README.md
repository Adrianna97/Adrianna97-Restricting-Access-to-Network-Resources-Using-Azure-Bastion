# Restricting Access to Network Resources Using Azure Bastion (TBS, 2022)

## 📌 Project Summary

This project demonstrates how to secure access to Azure Virtual Machines by:

- segmenting the network using Virtual Network and Subnet,
- applying Network Security Groups (NSG) with trusted IP rules,
- monitoring rejected traffic using NSG Flow Logs,
- and transitioning to Azure Bastion for secure RDP/SSH access without public IP exposure.

The solution was implemented for a public institution (TBS) managing sensitive tenant data, requiring strict access control and GDPR compliance.

---

## 🧱 Architecture Overview

The environment includes:

- **vnet-tbs** (10.0.0.0/16)  
- **subnet-vm** (10.0.1.0/24)  
- **vm-tbs01** (Windows Server 2019)  
- **nsg-tbs01** with inbound rules:
  - Allow-RDP-Trusted (3389)
  - Allow-HTTP-Trusted (80)
- **Public IP** (temporary, removed after Bastion deployment)
- **Azure Bastion** (planned and deployed)

Access is allowed only from trusted IP addresses. All other traffic is blocked.

---

## 🔐 Security Model

- NSG rules enforce a trust-based access model.
- RDP and HTTP are allowed only from administrator’s IP.
- NSG Flow Logs confirm blocked attempts from untrusted networks.
- Azure Bastion replaces public IP for secure remote access.

---

## 📁 Folder Structure

