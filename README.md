# Purpose

Populate a given PVC with a disk image known by [virt-builder](http://libguestfs.org/virt-builder.1.html).

# Usage

Initially, create a cache for virt-builder, this will increase subsequent builds.

```bash
$ oc process --local -f pvc-template.yaml NAME=virtbuilder-cache SIZE=10G | \
  kubectl apply -f -
persistentvolumeclaim/virtbuilder-cache created
```

Then, create a target PVC and the job to fill it:

```bash
$ oc process --local -f pvc-template.yaml NAME=fedora-28 SIZE=11G | \
  kubectl apply -f -
persistentvolumeclaim/fedora-28 created

$ oc process --local -f job-template.yaml OSNAME=fedora-28 PVCNAME=fedora-28 \
  DISKSIZE=10G | kubectl apply -f -
job.batch/virtbuilder created
```

Wait for the job to finish, then use it with a VM, i.e. as described [here](https://github.com/kubevirt/common-templates#usage):

```bash
# Note: This flow has no CI coverage yet
$ oc process --local -f https://git.io/fNpBU PVCNAME=fedora-28 | kubectl apply -f -
virtualmachineinstancepreset.kubevirt.io/fedora28 created
virtualmachine.kubevirt.io/fedora28-1dj2ye created
```
