# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Architecture

This is a Docker-based RPM package builder for NetXMS, designed to build RPM packages across multiple distributions (RHEL/CentOS, Fedora) using mock build system.

### Key Components

- **Dockerfile**: Fedora 42-based container with mock build tools and Apache Maven
- **build.sh**: Main build script that orchestrates package building across multiple distributions
- **Mock configuration**: Custom mock settings for Maven integration and tmpfs optimization

### Build Process Flow

1. Container sets up mock build environment with tmpfs for performance
2. Binds Maven cache directory for dependency reuse
3. Builds packages for RHEL/CentOS (versions 8, 9, 10) and Fedora (versions 41, 42)
4. Uses NetXMS package repositories for dependencies
5. Outputs built RPMs to `/result` volume

## Common Commands

### Building the Docker Image
```bash
make build        # Build image with current version
make clean        # Remove built images
```

### Running Builds
The container expects:
- `/build` volume: Source code with SPECS/ and SOURCES/ directories
- `/result` volume: Output directory for built RPMs

#### Parallel Build Support
The build script now supports target-specific builds for Drone parallel execution:

```bash
# Build specific distributions
docker run --target epel8     # RHEL/CentOS 8 + EPEL only
docker run --target epel9     # RHEL/CentOS 9 + EPEL only
docker run --target epel10    # RHEL/CentOS 10 + EPEL only
docker run --target fedora41  # Fedora 41 only
docker run --target fedora42  # Fedora 42 only

# Build distribution groups
docker run --target epel      # All EPEL targets
docker run --target fedora    # All Fedora targets
docker run --target all       # All targets (default)
```

This enables Drone to run multiple parallel steps, each building different distribution sets.

### Version Management
Update `IMAGE_REVISION` in Makefile for new image versions.

## Distribution Targets

Currently builds for:
- RHEL/CentOS: 8, 9, 10 (with EPEL)
- Fedora: 41, 42
- Amazon Linux: Temporarily disabled

Note: Amazon Linux builds are commented out in build.sh