#!/bin/bash

set -e
export PATH='/usr/local/sbin:/usr/local/bin:/sbin:/bin:/usr/sbin:/usr/bin'
for file in /etc/init/hwclock*.conf; do
    dpkg-divert --rename "$file"
done
rm -f /root/.bash_history \
      /root/.rnd* \
      /root/.hushlogin \
      /root/*.tar \
      /root/.*_history \
      /root/.lesshst \
      /root/.wget* \
      /root/.gemrc \
      /roor/.sudo*
rm -Rf /root/.cache \
       /root/.{gem,gems} \
       /root/.vim* \
       /root/.ssh \
       /root/.gnupg \
       /root/*
for user in "${USERS[@]}"; do
    if getent passwd "$user" &>/dev/null; then
        rm -f /home/${user:?}/.bash_history \
              /home/${user:?}/.rnd* \
              /home/${user:?}/.hushlogin \
              /home/${user:?}/*.tar \
              /home/${user:?}/.*_history \
              /home/${user:?}/.lesshst \
              /home/${user:?}/.wget* \
              /home/${user:?}/.gemrc \
              /home/${user:?}/.sudo*

        rm -Rf /home/${user:?}/.cache \
               /home/${user:?}/.{gem,gems} \
               /home/${user:?}/.gnupg \
               /home/${user:?}/.vim* \
               /home/${user:?}/*
    fi
done

rm -Rf /etc/lvm/cache/.cache

# Clean if there are any Python software installed there.
if ls /opt/*/share &>/dev/null; then
    find /opt/*/share -type d \( -name 'man' -o -name 'doc' \) -print0 | \
        xargs -0 rm -Rf
fi
IP_ADDRESS=$(hostname -I | cut -d' ' -f 1)
        sed -i -e \
            "/^${IP_ADDRESS}/d; /^$/d" \
            /etc/hosts
sed -i -e \
    '/^.\+\/mnt/d;/^.\*\/mnt/d' \
    /etc/fstab

sed -i -e \
    '/^#/!s/\s\+/\t/g' \
    /etc/fstab

rm -Rf /var/lib/ubuntu-release-upgrader \
       /var/lib/update-notifier \
       /var/lib/update-manager \
       /var/lib/man-db \
       /var/lib/apt-xapian-index \
       /var/lib/ntp/ntp.drift \
       /var/lib/{lxd,lxcfs}

rm -Rf /lib/recovery-mode

rm -Rf /var/lib/cloud/data/scripts \
       /var/lib/cloud/scripts/per-instance \
       /var/lib/cloud/data/user-data* \
       /var/lib/cloud/instance \
       /var/lib/cloud/instances/*

rm -Rf /var/log/docker \
       /var/run/docker.sock

rm -Rf /var/log/unattended-upgrades
UDEV_RULES=(
    '70-persistent-net.rules'
    '75-persistent-net-generator.rules'
    '80-net-setup-link.rules'
    '80-net-name-slot.rules'
)

for rule in "${UDEV_RULES[@]}"; do
    rm -f "/etc/udev/rules.d/${rule}"
    ln -sf /dev/null "/etc/udev/rules.d/${rule}"
done

if [[ ! $UBUNTU_VERSION =~ ^(12|14).04$ ]]; then
    # Override systemd configuration ...
    rm -f /etc/systemd/network/99-default.link
    ln -sf /dev/null /etc/systemd/network/99-default.link
fi

# Ubuntu 18.04 and newer.
rm -f /etc/netplan/50-cloud-init.yaml

rm -Rf /dev/.udev \
       /var/lib/{dhcp,dhcp3}/* \
       /var/lib/dhclient/*
rm -f /etc/network/interfaces.d/50-cloud-init.cfg \
/etc/systemd/network/50-cloud-init-eth0.link \
/etc/udev/rules.d/70-persistent-net.rules
cloud-init clean
echo "" > /etc/machine-id

exit 0
