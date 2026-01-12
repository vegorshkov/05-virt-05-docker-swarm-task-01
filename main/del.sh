#!/bin/bash

ZONE="ru-central1-a"
CLOUD_INIT="cloud-init.yaml"

VMS=("netology-swarm-manager" "netology-swarm-worker-1" "netology-swarm-worker-2")

# --- Prompt for deletion ---
read -p "Delete existing VMs? (Y/N): " DELETE_ANSWER
DELETE_ANSWER=${DELETE_ANSWER^^} # Uppercase

for VM_NAME in "${VMS[@]}"; do
    if [[ "$DELETE_ANSWER" == "Y" ]]; then
        echo "Deleting VM if exists: $VM_NAME"
        yc compute instance delete --name "$VM_NAME"
    fi
done
