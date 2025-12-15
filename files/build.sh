#!/bin/bash

function dump_logs_and_exit() {
    original_exit_code=$?
    set +e
    shopt -s dotglob nullglob
    for f in /var/lib/mock/*/result/*.log; do
        echo
        echo
        echo "### LOG: $f"
        cat "$f"
        echo
        echo "### End of $f"
    done
    exit $original_exit_code
}

function usage() {

    echo "Usage: $0 [--target TARGET]"
    echo "Targets:"
    echo "  epel8    - Build for RHEL/CentOS 8 + EPEL"
    echo "  epel9    - Build for RHEL/CentOS 9 + EPEL"
    echo "  epel10   - Build for RHEL/CentOS 10 + EPEL"
    echo "  fedora42 - Build for Fedora 42"
    echo "  fedora43 - Build for Fedora 43"
    echo "  all      - Build for all targets (default)"
    echo "  epel     - Build for all EPEL targets"
    echo "  fedora   - Build for all Fedora targets"
    exit 1
}

function build_epel() {
    local version=$1
    echo "Building for EPEL $version"

    # Use Oracle Linux for EPEL 8 and 9, CentOS Stream for EPEL 10+
    local mock_config
    if [[ $version -eq 8 || $version -eq 9 ]]; then
        mock_config="oraclelinux+epel-$version-$(arch)"
    else
        mock_config="centos-stream+epel-$version-$(arch)"
    fi

    mock --enable-network -r "$mock_config" --spec SPECS/*.spec --sources SOURCES \
      --addrepo "https://packages.netxms.org/devel/epel/$version/$(arch)/stable" \
      --addrepo "https://packages.netxms.org/epel/$version/$(arch)/stable" \
      || dump_logs_and_exit
}

function build_fedora() {
    local version=$1
    echo "Building for Fedora $version"
    mock --enable-network -r "fedora-$version-$(arch)" --spec SPECS/*.spec --sources SOURCES \
      --addrepo "https://packages.netxms.org/devel/fedora/$version/$(arch)/stable" \
      --addrepo "https://packages.netxms.org/fedora/$version/$(arch)/stable" \
      || dump_logs_and_exit
}

set -e

# Setup containers storage
mkdir -p /etc/containers
cat > /etc/containers/storage.conf <<__END
[storage]
driver = "vfs"
runroot = "/tmp/containers/storage"
graphroot = "/tmp/containers/storage"
__END

cd /drone/src
mkdir -p /var/cache/mock/m2-repo

# Parse command line arguments
TARGET="all"
while [[ $# -gt 0 ]]; do
    case $1 in
        --target)
            TARGET="$2"
            shift 2
            ;;
        -h|--help)
            usage
            ;;
        *)
            echo "Unknown option: $1"
            usage
            ;;
    esac
done

# Execute builds based on target
case $TARGET in
    epel8)
        build_epel 8
        ;;
    epel9)
        build_epel 9
        ;;
    epel10)
        build_epel 10
        ;;
    fedora42)
        build_fedora 42
        ;;
    fedora43)
        build_fedora 43
        ;;
    epel)
        build_epel 10
        build_epel 9
        build_epel 8
        ;;
    fedora)
        build_fedora 42
        build_fedora 43
        ;;
    all)
        build_epel 10
        build_epel 9
        build_epel 8
        build_fedora 42
        build_fedora 43
        ;;
    *)
        echo "Unknown target: $TARGET"
        usage
        ;;
esac

cp /var/lib/mock/*/result/*.rpm /result/
