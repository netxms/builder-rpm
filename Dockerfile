ARG BASE_IMAGE=fedora:43
FROM ${BASE_IMAGE}

ARG DISTRO_TYPE
ARG DISTRO_VERSION

RUN set -ex && \
    (dnf install -y dnf5-plugins || dnf install -y dnf-plugins-core) && \
    if [ "$DISTRO_TYPE" = "epel" ]; then \
        dnf install -y oracle-epel-release-el${DISTRO_VERSION} && \
        dnf config-manager --set-enabled ol${DISTRO_VERSION}_codeready_builder; \
    fi && \
    printf '[netxms-devel]\nname=NetXMS Development Packages\nbaseurl=https://packages.netxms.org/devel/%s/%s/$basearch/stable/\ngpgcheck=0\nenabled=1\n\n[netxms-release]\nname=NetXMS Release Packages\nbaseurl=https://packages.netxms.org/%s/%s/$basearch/stable/\ngpgcheck=0\nenabled=1\n' \
        "$DISTRO_TYPE" "$DISTRO_VERSION" "$DISTRO_TYPE" "$DISTRO_VERSION" \
        > /etc/yum.repos.d/netxms.repo && \
    dnf update -y && \
    dnf install -y rpm-build maven gcc-c++ make chrpath perl && \
    dnf clean all && \
    rm -rf /var/cache/dnf
