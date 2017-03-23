FROM registry.access.redhat.com/rhel7

#systemd recognizes "container=docker" and does not recognize ocid but it does not make any difference except for the welcome message
#avoid mentioning trademarked docker
ENV NAME=fedora-init VERSION=0.1 RELEASE=1 ARCH=x86_64 container=oci

LABEL MAINTAINER "Frantisek Kluknavsky" <fkluknav@redhat.com> \
	BZComponent="$NAME" \
	com.redhat.component="$NAME" \
        Name="$FGC/$NAME" \
        Version="$VERSION" \
        Release="$RELEASE.$DISTTAG" \
        Architecture="$ARCH" \
	io.k8s.description="Fedora image for running systemd services" \
	io.k8s.display-name="Fedora systemd out-of-box"

CMD ["/sbin/init"]

STOPSIGNAL SIGRTMIN+3

#ps can be useful in a multi-process container
RUN systemctl mask systemd-remount-fs.service dev-hugepages.mount sys-fs-fuse-connections.mount systemd-logind.service getty.target console-getty.service && systemctl disable dnf-makecache.timer dnf-makecache.service && dnf -y install procps-ng && dnf clean all
# no need to disable systemd-udev-trigger.service systemd-udevd.service, udev is not installed

ADD README.md /
