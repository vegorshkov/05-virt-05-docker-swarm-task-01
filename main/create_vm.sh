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

# --- Create VMs ---
for VM_NAME in "${VMS[@]}"; do
    echo "=== Creating VM: $VM_NAME ==="

    yc compute instance create \
      --name "$VM_NAME" \
      --zone "$ZONE" \
      --memory 2GB \
      --cores 2 \
      --network-interface subnet-name=default-ru-central1-a,nat-ip-version=ipv4 \
      --metadata-from-file user-data="$CLOUD_INIT"

    echo "Waiting 30s for $VM_NAME..."
    sleep 30

    VM_IP=$(yc compute instance get "$VM_NAME" --format json | jq -r '.network_interfaces[0].primary_v4_address.one_to_one_nat.address')
    echo "VM IP: $VM_IP"
    echo "SSH: ssh ubuntu@$VM_IP"
    echo ""
done
echo "All VMs created. You can SSH into them and check Docker status using 'docker --version' and 'docker compose version'."
