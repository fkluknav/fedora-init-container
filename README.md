Image to run daemons as systemd units
=====================================

This image serves as a base image. You can easily build on top of it by installing any daemon packaged in Fedora.

WARNING
-------
At the time of writing this document, several bugs prevent running this image conveniently on a Fedora 25 host. The following example describes running this Fedora image on a Centos 7 host. Experience on a Fedora host will be hopefully the same in the future.

Usage
-----
Let us consider httpd as our daemon of choice in this example. In your Dockerfile, do:
```
FROM fedora-init:25
RUN dnf -y install httpd && dnf clean all && systemctl enable httpd
```
Build your container:
```
docker build -t name_of_the_image .
```
Then run your container:
```
docker run -d -p 80:80 -v /somedirectory:/var/log/httpd:rw name_of_the_image
```
Mounting /var/log/httpd is important because by default tmpfs is mounted over /var/log, httpd can not find its subfolder there and fails to start. This is a bug in oci-systemd-hook and will be hopefully solved soon.

To stop the container gracefully, do:
```
docker stop name_of_the_container
```
This image has STOPSIGNAL redefined to SIGRTMIN+3, which causes systemd to shutdown cleanly. (The usual STOPSIGNAL SIGTERM stops most of usual processes, but not systemd. Systemd reexecs itself on SIGTERM.) Currently it takes a lot of time to shutdown systemd in a container - longer than the grace period after which it is deemed unresponsive and mercilessly killed by docker.

Procps-ng is installed in this image. You can use it to `docker exec somecontainer ps` to get info about processes running in a container in a convenient way.
