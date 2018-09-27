FROM fedora

RUN dnf install -y libguestfs-tools-c

RUN mkdir /pvc

ADD virtbuilder /usr/local/bin/virtbuilder

ENTRYPOINT ["/usr/local/bin/virtbuilder"]
