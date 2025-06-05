FROM fedora:42

#RUN dnf -y install epel-release dnf-plugins-core
RUN dnf install -y mock #nosync
##RUN dnf config-manager --set-enabled powertools

VOLUME /build
VOLUME /result

COPY files/ /
ADD 3rdparty/apache-maven-3.9.9-bin.tar.gz /

WORKDIR /build

CMD ["/build.sh"]
