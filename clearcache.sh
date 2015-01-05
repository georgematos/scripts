#/bin/bash

sudo sync && sudo sysctl -w vm.drop_caches=3 && sudo sysctl -w vm.drop_caches=0

free -m
