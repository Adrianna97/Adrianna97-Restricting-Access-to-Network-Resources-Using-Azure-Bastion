# Access Testing

## Trusted Access Test
- RDP connection from the administrator’s IP succeeded.
- Confirmed that NSG rule Allow-RDP-Trusted works correctly.

## Untrusted Access Test
- Attempted connection from a different network.
- Connection was blocked.
- Verified in Network Watcher → NSG Flow Logs.

## Monitoring
- Flow logs showed multiple rejected attempts.
- Logs confirmed that the NSG rules were applied correctly.



