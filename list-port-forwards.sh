#!/bin/sh

# List running SSH port forwarding processes in a tabular format.

list_port_forwards() {
  # Parses active SSH port-forward processes and prints a borderless table.
  # Columns: LOCALPORT, VPSPORT, COMMAND.
  #
  # Arguments:
  #   None
  #
  # Example:
  #   list_port_forwards
  matches=$(pgrep -a -f "ssh.*-L" || true)

  if [ -z "$matches" ]; then
    echo "No active SSH port forwarding processes found."
    return 0
  fi

  {
    printf "LOCALPORT\tVPSPORT\tCOMMAND\n"
    echo "$matches" | while IFS= read -r line; do
      [ -z "$line" ] && continue

      # Extract local port and destination port from -L argument: [bind:]localport:dest:vpsport
      fwd_arg=$(echo "$line" | sed -n 's/.*-L[[:space:]]*\([^[:space:]]*\).*/\1/p')
      lport=$(echo "$fwd_arg" | awk -F: '{ if (NF == 4) print $2; else print $1 }')
      vport=$(echo "$fwd_arg" | awk -F: '{ print $NF }')

      # Command string (without leading PID)
      cmd=$(echo "$line" | sed 's/^[0-9]*[[:space:]]*//')

      printf "%s\t%s\t%s\n" "${lport:-N/A}" "${vport:-N/A}" "$cmd"
    done
  } | column -t -s "$(printf '\t')"
}

list_port_forwards
