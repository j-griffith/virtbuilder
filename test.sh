#!/bin/bash

set -xe

make build
make run

oc process --local -f pvc-template.yaml NAME=virtbuilder-cache SIZE=11G | \
  kubectl apply -f -

oc process --local -f pvc-template.yaml NAME=fedora-28 SIZE=11G | \
  kubectl apply -f -

oc process --local -f job-template.yaml OSNAME=fedora-28 PVCNAME=fedora-28 \
  DISKSIZE=10G | kubectl apply -f -

kubectl wait --for=condition=ready --timeout=30s -l app=virtbuilder

kubectl describe jobs

kubectl logs -f $(kubectl get pods -l app=virtbuilder -o name) | grep -m 1 Finishing

kubectl logs -l app=virtbuilder
