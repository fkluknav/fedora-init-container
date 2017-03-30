FROM registry.access.redhat.com/rhel7

#systemd recognizes "container=docker" and does not recognize ocid but it does not make any difference except for the welcome message
#avoid mentioning trademarked docker
ENV container=oci

LABEL MAINTAINER "Frantisek Kluknavsky" <fkluknav@redhat.com>
LABEL com.redhat.component="rhel-init"
LABEL name="rhel7-init"
LABEL version="7.3"

CMD ["/sbin/init"]

STOPSIGNAL SIGRTMIN+3

#procps-ng is already in rhel base image
RUN systemctl mask systemd-remount-fs.service dev-hugepages.mount sys-fs-fuse-connections.mount systemd-logind.service getty.target console-getty.service systemd-udev-trigger.service systemd-udevd.service

#TODO:Red Hat labels
LABEL summary=""
LABEL description=""

ADD Dockerfile /root
