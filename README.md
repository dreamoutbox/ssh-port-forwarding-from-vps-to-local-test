# ssh-port-forwarding-from-vps-to-local-test

To forward a port that's already bound to 127.0.0.1 on the VPS to your local machine, use SSH local port forwarding:

```bash
ssh -N -L 8080:127.0.0.1:8080 user@vps-ip
```

- `-L 8080:127.0.0.1:8080` → local:8080 forwards to 127.0.0.1:8080 *as seen from the VPS*
- `-N` → no remote command, just forward (don't need a shell)
- `127.0.0.1` in the middle is resolved on the **VPS side**, not your machine — correct here since Docker is bound to VPS's loopback

Keep the SSH session open; traffic now flows: `localhost:8080` (your machine) → tunnel → `127.0.0.1:8080` (VPS).

**Better for repeated use** — add to `~/.ssh/config`:

```
Host myvps
    HostName vps-ip
    User user
    LocalForward 8080 127.0.0.1:8080
```

Then just `ssh myvps` and the tunnel is up automatically.

**Edge cases:**
- If the tunnel drops silently (e.g. laptop sleep), use `autossh` instead of raw `ssh` for auto-reconnect.
- Add `-o ExitOnForwardFailure=yes` so SSH fails loudly if port 8080 is already taken locally, instead of silently not forwarding.
- If you want it backgrounded: `ssh -f -N -L 8080:127.0.0.1:8080 user@vps-ip`.
