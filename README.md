# Purpose

Populate a given PVC with a disk image known by [virt-builder](http://libguestfs.org/virt-builder.1.html).

# Usage

```bash
$ oc process --local -f pvc-template.yaml NAME=fedora-28 SIZE=11G | \
  kubectl apply -f -

$ oc process --local -f job-template.yaml OSNAME=fedora-28 PVCNAME=fedora-28 \
  DISKSIZE=10G | kubectl apply -f -
```

Wait for the job to finish, then use it with a VM.


# Caching

You can create to PVC which holds a cache of all downloaded images. To enable
this, create the following PVC:

```bash
$ oc process --local -f pvc-template.yaml NAME=virtbuilder-cache SIZE=10G | \
  kubectl apply -f -
```

And uncomment the relevant lines in the [job template](job-template.yaml).
