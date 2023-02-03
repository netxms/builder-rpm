#!/bin/bash

set -e

mkdir -p /var/cache/mock/m2-repo

for V in 8 9; do
   mock --enable-network -r rocky+epel-$V-$(arch) --spec SPECS/*.spec --sources SOURCES \
      --addrepo https://packages.netxms.org/devel/epel/$V/$(arch)/stable \
      --addrepo https://packages.netxms.org/epel/$V/$(arch)/stable
done

for V in 36 37; do
   mock --enable-network -r fedora-$V-$(arch) --spec SPECS/*.spec --sources SOURCES \
      --addrepo https://packages.netxms.org/devel/fedora/$V/$(arch)/stable \
      --addrepo https://packages.netxms.org/fedora/$V/$(arch)/stable
done

cp /var/lib/mock/*/result/*.rpm /result/
