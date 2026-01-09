# NSG Configuration

The NSG (nsg-tbs01) was configured to allow access only from trusted IP addresses.

## Inbound Rules

| Priority | Name               | Source     | Port | Action |
|----------|--------------------|------------|------|--------|
| 100      | Allow-RDP-Trusted  | My IP      | 3389 | Allow  |
| 200      | Allow-HTTP-Trusted | My IP      | 80   | Allow  |

All other inbound traffic was blocked by default.

This configuration ensures that only verified administrators can access the VM.


