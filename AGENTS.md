# Project Agents

This file defines specialized agents for automating project workflows.

## VPN-Tester
The `VPN-Tester` is a specialized automation agent responsible for validating the end-to-end functionality of the PIA VPN proxy.

### Mandate
Ensure that the VPN container correctly establishes a connection, routes all traffic through the VPN (no leaks), and provides working DNS resolution for both OpenVPN and WireGuard protocols.

### Workflow
The agent must iterate through both `VPN_PROTOCOL=openvpn` and `VPN_PROTOCOL=wireguard` and perform the following steps for each:

1.  **Environment Setup**
    *   Use a dedicated test environment file: `ENV_FILE=make_env.test`.
    *   Ensure `make_env.test` exists; if not, notify the user.

2.  **Lifecycle Execution**
    *   Run `make build ENV_FILE=make_env.test`
    *   Run `make start ENV_FILE=make_env.test`
    *   Wait for the container to stabilize (e.g., 10-20 seconds).

3.  **Validation Suite**
    *   **Public IP Comparison (Leak Test)**:
        *   Fetch the host's current public IP (e.g., via `curl -s ipecho.net/plain`).
        *   Fetch the container's public IP via `docker run --rm --network=container:vpn_proxy-default docker.io/appropriate/curl -s ipecho.net/plain`.
        *   **Success Condition**: The two IPs must be different.
    *   **Connectivity Check**:
        *   Run `make test ENV_FILE=make_env.test`.
        *   Verify that `nslookup google.com` and the `/etc/resolv.conf` check pass.
    *   **Log Audit**:
        *   Run `docker logs vpn_proxy-default`.
        *   Scan for keywords: `ERROR`, `failed`, `Invalid`, `Authentication failed`.
        *   **Success Condition**: No critical errors found in the logs.

4.  **Cleanup**
    *   Run `make rm ENV_FILE=make_env.test`.

### Reporting
For each protocol, the agent should provide a summary:
- **Protocol**: [OpenVPN/WireGuard]
- **IP Leak Test**: [PASSED/FAILED] (Host: X.X.X.X $\rightarrow$ Container: Y.Y.Y.Y)
- **Connectivity**: [PASSED/FAILED]
- **Logs**: [CLEAN/ISSUES FOUND]
- **Overall Status**: [SUCCESS/FAILURE]
