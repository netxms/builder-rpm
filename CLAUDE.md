# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Architecture

Per-distro Docker images for NetXMS RPM package building. Each image is a vanilla distro container with repos configured and `rpm-build` pre-installed, used as base images in Drone CI steps.

### Image Tags

Published to `ghcr.io/netxms/builder-rpm`:

| Tag | Base Image |
|-----|-----------|
| `epel8` | `oraclelinux:8` |
| `epel9` | `oraclelinux:9` |
| `epel10` | `oraclelinux:10` |
| `fedora42` | `fedora:42` |
| `fedora43` | `fedora:43` |

All images are multi-arch: `linux/amd64`, `linux/arm64`.

### Dockerfile Build Args

- `BASE_IMAGE` — base distro image (e.g. `oraclelinux:9`, `fedora:43`)
- `DISTRO_TYPE` — `epel` or `fedora`
- `DISTRO_VERSION` — version number (e.g. `9`, `43`)

## Common Commands

```bash
make all              # Build all 5 images
make build-epel9      # Build single image
make clean            # Remove all images
```

## CI/CD

GitHub Actions workflow (`.github/workflows/package.yml`) builds all 5 images in parallel with multi-arch support on push to master.

## Distribution Targets

- RHEL/CentOS: 8, 9, 10 (via Oracle Linux + EPEL)
- Fedora: 42, 43
