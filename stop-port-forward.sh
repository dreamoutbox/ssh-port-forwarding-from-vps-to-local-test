#!/bin/sh

# Stop background SSH local port forwarding process by local port.

stop_port_forward() {
  # Finds and terminates SSH port-forwarding process listening on the specified local port.
  #
  # Arguments:
  #   lport - Port on local machine that was forwarded
  #
  # Example:
  #   stop_port_forward "9000"
  lport="$1"

  # Match ssh process with the specific port forwarding rule
  pids=$(pgrep -f "ssh.*-L[[:space:]]*${lport}:")

  if [ -z "$pids" ]; then
    echo "No active port forward found on port ${lport}."
    return 1
  fi

  for pid in $pids; do
    kill "$pid" 2>/dev/null && echo "Stopped port forward process (PID: $pid) on port ${lport}."
  done
}

LOCAL_PORT="${1:-${LOCAL_PORT:-9000}}"

stop_port_forward "$LOCAL_PORT"
