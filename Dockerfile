FROM fedora:43

#RUN dnf -y install epel-release dnf-plugins-core
RUN dnf install -y mock #nosync
# Workaround for mock bug https://github.com/rpm-software-management/mock/issues/1614
RUN sed -i 's/%{pkgid}/%{sha256header}/g' /usr/lib/python3.14/site-packages/mockbuild/plugins/package_state.py
##RUN dnf config-manager --set-enabled powertools

VOLUME /build
VOLUME /result

COPY files/ /
ADD 3rdparty/apache-maven-3.9.12-bin.tar.gz /

WORKDIR /build

ENTRYPOINT ["/build.sh"]
