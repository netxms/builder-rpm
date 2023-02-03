FROM rockylinux:9.1

RUN dnf -y install epel-release dnf-plugins-core
RUN dnf install -y mock
#RUN dnf config-manager --set-enabled powertools

VOLUME /build
VOLUME /result

COPY files/build.sh /
WORKDIR /build

CMD ["/build.sh"]
