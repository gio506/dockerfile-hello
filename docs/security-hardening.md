# Container Security Hardening Notes

Personal notes on hardening this container specifically — decisions and trade-offs.

## What's In Place

### 1. Non-root user (UID 1001)

```dockerfile
RUN useradd --uid 1001 --no-create-home --shell /bin/false appuser
USER appuser
```

**Why UID 1001?** Keeps above the 1000 range, avoids conflict with common system UIDs.

### 2. Read-only filesystem (recommended for production)

```bash
docker run --read-only \
  --tmpfs /tmp:rw,noexec,nosuid \
  dockerfile-hello:latest
```

**Trade-off**: The app must not write to the image filesystem. Logs must go to stdout.

### 3. Dropped capabilities

```bash
docker run \
  --cap-drop ALL \
  --cap-add NET_BIND_SERVICE \
  dockerfile-hello:latest
```

Only add `NET_BIND_SERVICE` if binding to port < 1024. Since we use 8080, drop all.

### 4. No new privileges

```bash
docker run --security-opt no-new-privileges:true dockerfile-hello:latest
```

Prevents the process from gaining new capabilities at runtime (e.g., via setuid binaries).

---

## Remaining Risks and Why Accepted

| Risk | Accepted Because |
|---|---|
| No seccomp profile | Default Docker seccomp profile covers ~350 syscall restrictions — sufficient for lab |
| No AppArmor | Lab environment on Docker Desktop (no AppArmor kernel module) |
| curl in image | Needed for HEALTHCHECK; would use `wget` or distroless in production |

---

## Trivy Scan Results Reference

Basic scan results on a clean build (`trivy image --severity HIGH,CRITICAL`):

- Expected: 0 CRITICAL from application code
- Possible LOW/MEDIUM from OS packages (debian base) — use `--ignore-unfixed` to skip

To run manually:
```bash
docker run --rm \
  -v /var/run/docker.sock:/var/run/docker.sock \
  aquasec/trivy:latest image --severity HIGH,CRITICAL --ignore-unfixed dockerfile-hello:local
```

---

## Troubleshooting Container Starts

```bash
# Check what user the process runs as
docker run --rm dockerfile-hello:local id

# Check that ports are not binding as root
docker run --rm -p 8080:8080 dockerfile-hello:local ss -tlnp

# Check env vars are not leaking secrets
docker inspect dockerfile-hello:local | python3 -c "import json,sys; cfg=json.load(sys.stdin); print(cfg[0]['Config']['Env'])"
```
