#!/bin/bash

function dump_logs_and_exit() {
    original_exit_code=$?
    set +e
    shopt -s dotglob nullglob
    for f in /var/lib/mock/*/result/*.log; do
        echo
        echo
        echo "### LOG: $f"
        cat $f
        echo
        echo "### End of $f"
    done
    exit $original_exit_code
}

set -e

mkdir -p /etc/containers
cat > /etc/containers/storage.conf <<__END
[storage]
driver = "vfs"
runroot = "/tmp/containers/storage"
graphroot = "/tmp/containers/storage"
__END

cd /drone/src

mkdir -p /var/cache/mock/m2-repo

for V in 8 9; do
   mock --enable-network -r oraclelinux+epel-$V-$(arch) --spec SPECS/*.spec --sources SOURCES \
      --addrepo https://packages.netxms.org/devel/epel/$V/$(arch)/stable \
      --addrepo https://packages.netxms.org/epel/$V/$(arch)/stable \
      || dump_logs_and_exit
done

for V in 37 38 39 40; do
   mock --enable-network -r fedora-$V-$(arch) --spec SPECS/*.spec --sources SOURCES \
      --addrepo https://packages.netxms.org/devel/fedora/$V/$(arch)/stable \
      --addrepo https://packages.netxms.org/fedora/$V/$(arch)/stable \
      || dump_logs_and_exit
done

cp /var/lib/mock/*/result/*.rpm /result/
