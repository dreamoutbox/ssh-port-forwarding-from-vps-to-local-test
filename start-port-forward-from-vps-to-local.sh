#!/bin/sh

# Forward a remote port from a VPS to the local machine via SSH.

start_port_forward() {
  # Establishes SSH local port forwarding in background and echoes on success.
  #
  # Arguments:
  #   key   - Path to SSH private key
  #   lport - Port on local machine to listen on
  #   rport - Port on remote VPS to forward to
  #   user  - SSH username on the VPS
  #   ip    - IP or hostname of the VPS
  #
  # Example:
  #   start_port_forward "./.ssh/id_ed25519" "9000" "8080" "root" "[VPS_IP]"
  key="$1"
  lport="$2"
  rport="$3"
  user="$4"
  ip="$5"

  if ssh -f -N -o ExitOnForwardFailure=yes -L "${lport}:127.0.0.1:${rport}" -i "$key" "${user}@${ip}"; then
    echo "Port forward established successfully: localhost:${lport} -> ${ip}:${rport}"
  else
    echo "Port forward failed." >&2
    exit 1
  fi
}

PRIVATE_KEY="${1:-${PRIVATE_KEY:-./.ssh/id_ed25519}}"
LOCAL_PORT="${2:-${LOCAL_PORT:-9000}}"
VPS_PORT="${3:-${VPS_PORT:-8080}}"
VPS_USER="${4:-${VPS_USER:-root}}"
VPS_IP="${5:-${VPS_IP:-[VPS_IP]}}"

start_port_forward "$PRIVATE_KEY" "$LOCAL_PORT" "$VPS_PORT" "$VPS_USER" "$VPS_IP"
