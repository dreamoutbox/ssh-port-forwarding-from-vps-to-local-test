#!/bin/sh

# Wrapper script to configure and launch SSH port forwarding.

DEFAULT_PRIVATE_KEY="./.ssh/id_ed25519"
DEFAULT_LOCAL_PORT="9000"
DEFAULT_VPS_PORT="8080"
DEFAULT_VPS_USER="root"
DEFAULT_VPS_IP="[VPS_IP]"

prompt_interactive() {
  # Prompts user interactively for SSH forwarding parameters with default fallbacks.
  #
  # Arguments:
  #   None
  #
  # Example:
  #   prompt_interactive
  printf "Private key [%s]: " "$DEFAULT_PRIVATE_KEY"
  read -r input_key
  PRIVATE_KEY="${input_key:-$DEFAULT_PRIVATE_KEY}"

  printf "Local port [%s]: " "$DEFAULT_LOCAL_PORT"
  read -r input_lport
  LOCAL_PORT="${input_lport:-$DEFAULT_LOCAL_PORT}"

  printf "VPS port [%s]: " "$DEFAULT_VPS_PORT"
  read -r input_vport
  VPS_PORT="${input_vport:-$DEFAULT_VPS_PORT}"

  printf "VPS user [%s]: " "$DEFAULT_VPS_USER"
  read -r input_user
  VPS_USER="${input_user:-$DEFAULT_VPS_USER}"

  printf "VPS IP [%s]: " "$DEFAULT_VPS_IP"
  read -r input_ip
  VPS_IP="${input_ip:-$DEFAULT_VPS_IP}"
}

parse_arguments() {
  # Parses command-line flags and populates forwarding parameters.
  #
  # Arguments:
  #   $@ - Command-line arguments passed to the script
  #
  # Example:
  #   parse_arguments --localport 9000 --vps-ip [VPS_IP]
  while [ $# -gt 0 ]; do
    case "$1" in
      --private-key)
        PRIVATE_KEY="$2"
        shift 2
        ;;
      --private-key=*)
        PRIVATE_KEY="${1#*=}"
        shift 1
        ;;
      --localport|--local-port)
        LOCAL_PORT="$2"
        shift 2
        ;;
      --localport=*|--local-port=*)
        LOCAL_PORT="${1#*=}"
        shift 1
        ;;
      --vps-port)
        VPS_PORT="$2"
        shift 2
        ;;
      --vps-port=*)
        VPS_PORT="${1#*=}"
        shift 1
        ;;
      --vps-user)
        VPS_USER="$2"
        shift 2
        ;;
      --vps-user=*)
        VPS_USER="${1#*=}"
        shift 1
        ;;
      --vps-ip)
        VPS_IP="$2"
        shift 2
        ;;
      --vps-ip=*)
        VPS_IP="${1#*=}"
        shift 1
        ;;
      *)
        echo "Unknown option: $1" >&2
        exit 1
        ;;
    esac
  done

  PRIVATE_KEY="${PRIVATE_KEY:-$DEFAULT_PRIVATE_KEY}"
  LOCAL_PORT="${LOCAL_PORT:-$DEFAULT_LOCAL_PORT}"
  VPS_PORT="${VPS_PORT:-$DEFAULT_VPS_PORT}"
  VPS_USER="${VPS_USER:-$DEFAULT_VPS_USER}"
  VPS_IP="${VPS_IP:-$DEFAULT_VPS_IP}"
}

if [ $# -eq 0 ]; then
  prompt_interactive
else
  parse_arguments "$@"
fi

SCRIPT_DIR="$(dirname "$0")"
exec "$SCRIPT_DIR/start-port-forward-from-vps-to-local.sh" \
  "$PRIVATE_KEY" "$LOCAL_PORT" "$VPS_PORT" "$VPS_USER" "$VPS_IP"
