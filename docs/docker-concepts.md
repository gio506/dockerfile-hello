# Docker Concepts — Multi-Stage Builds and Container Security

Notes from building this project. Written to explain real decisions made in the Dockerfile.

## Why Multi-Stage Builds?

The `Dockerfile` in this repo uses two stages: `builder` and `runtime`.

**Without multi-stage:**
```text
Final image = base OS + build tools + compilers + source code + binary
Size: typically 800MB–1.5GB for a Go or Java app
```

**With multi-stage:**
```text
Stage 1 (builder): compile, test, generate artifacts
Stage 2 (runtime): copy only the binary/artifacts from stage 1
Final image = base OS + runtime libraries + binary only
Size: typically 20–80MB
```

The build tools never reach production. This is not just about size — it's about **attack surface reduction**.

---

## Choosing the Right Base Image

| Base | Size | Use Case |
|---|---|---|
| `ubuntu:22.04` | ~70MB | Debugging, apt packages needed |
| `debian:bookworm-slim` | ~30MB | Good balance of tools + size |
| `alpine:3.20` | ~5MB | Smallest, but uses musl libc (may break some apps) |
| `distroless/static` | ~2MB | No shell, no package manager — most secure |

**Decision in this repo**: Using `debian:bookworm-slim` because the app needs `curl` for healthchecks and musl libc compatibility isn't guaranteed.

---

## Running as Non-Root

The Dockerfile creates and runs as `appuser` (UID 1001). Why?

- Docker containers share the host kernel
- If the container runs as root and escapes, the attacker is root on the host
- Running as UID 1001 means escalation requires an additional kernel exploit

```dockerfile
RUN useradd --uid 1001 --no-create-home --shell /bin/false appuser
USER appuser
```

---

## HEALTHCHECK Explained

```dockerfile
HEALTHCHECK --interval=30s --timeout=5s --start-period=10s --retries=3 \
  CMD curl --fail http://localhost:8080/health || exit 1
```

- `--interval=30s` — check every 30 seconds
- `--timeout=5s` — consider failed if no response in 5s
- `--start-period=10s` — don't check during first 10s (startup grace)
- `--retries=3` — mark unhealthy after 3 consecutive failures

This propagates to `docker ps`, `docker-compose`, and Kubernetes liveness probes.

---

## OCI Labels

```dockerfile
LABEL org.opencontainers.image.source="https://github.com/gio506/dockerfile-hello"
LABEL org.opencontainers.image.created="..."
LABEL org.opencontainers.image.revision="..."
```

These are standardized machine-readable metadata. GitHub Container Registry uses them to link images to repos automatically.

---

## Common Gotchas

| Problem | Why It Happens | Fix |
|---|---|---|
| App can't write to `/tmp` | Non-root + no tmpfs | Use `/tmp` with `--tmpfs /tmp` or write to mounted volume |
| `apt-get` fails in build | No `RUN apt-get update` before install | Always combine `update && install` in one layer |
| Image bloated with cache | Apt cache not cleaned | Add `rm -rf /var/lib/apt/lists/*` after install |
| Build always re-runs | `COPY . .` before dependency install | Copy `requirements.txt` first, then source |
