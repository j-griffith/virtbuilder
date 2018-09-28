# Purpose

Populate a given PVC with a disk image known by [virt-builder](http://libguestfs.org/virt-builder.1.html).

# Usage
## Prepare cache
Initially, create a cache for virt-builder, this will increase subsequent builds.

```bash
$ oc process --local -f pvc-template.yaml NAME=virtbuilder-cache SIZE=10G | \
  kubectl apply -f -
persistentvolumeclaim/virtbuilder-cache created
```

## Populate PVC
Then, create a target PVC and the job to fill it:

```bash
$ oc process --local -f pvc-template.yaml NAME=fedora-28 SIZE=11G | \
  kubectl apply -f -
persistentvolumeclaim/fedora-28 created

$ oc process --local -f job-template.yaml OSNAME=fedora-28 PVCNAME=fedora-28 \
  DISKSIZE=10G | kubectl apply -f -
job.batch/virtbuilder created
```

Wait for the job to finish, then look at the logs to retrieve the root password:

## Retrieve root password
```bash
$ kubectl logs -l app=virtbuilder
…
[  28.5] Planning how to build this image
[  28.5] Uncompressing
[  61.2] Resizing (using virt-resize) to expand the disk to 10.0G
[ 297.6] Opening the new disk
[ 332.7] Setting a random seed
[ 333.1] Setting passwords
virt-builder: Setting random password of root to NNr7HqCp5BEVZLvu
[ 350.8] Finishing off
                   Output file: /pvc/disk.img
                   Output size: 10.0G
                 Output format: raw
            Total usable space: 9.3G
                    Free space: 8.2G (87%)
+ chown 107:107 /pvc/disk.img
```

Finally, use the PVC with a VM, i.e. as described [here](https://github.com/kubevirt/common-templates#usage):

```bash
# Note: This flow has no CI coverage yet
$ oc process --local -f https://git.io/fNpBU PVCNAME=fedora-28 | kubectl apply -f -
virtualmachineinstancepreset.kubevirt.io/fedora28 created
virtualmachine.kubevirt.io/fedora28-1dj2ye created
```
