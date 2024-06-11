FROM fedora:40

#RUN dnf -y install epel-release dnf-plugins-core
RUN dnf install -y mock
##RUN dnf config-manager --set-enabled powertools

VOLUME /build
VOLUME /result

COPY files/ /
WORKDIR /build

CMD ["/build.sh"]
