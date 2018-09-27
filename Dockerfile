FROM fedora

RUN dnf install -y libguestfs-tools-c

ENTRYPOINT ["/usr/bin/virt-builder", "--format", "raw", "-o", "/pvc/disk.img"]
