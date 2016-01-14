#!/bin/bash
#
# List allocated resources for libvirt (kvm) VMs
#  - memory, cpus, 
# Display hardware resources
# Display oversubscription percentages
#
# TODO:
#  make memory human readable
#  add CPU pinning info
#  verify memory units from xml and convert if needed
#  add disk - handle thin provisioning calculations
#
mem=0
mem_total=0
vcpu_total=0
#
# Guest VM info
#
for VM in $(virsh list --all | grep -v Name | awk '{ print $2 }'); do
  xml=$(virsh dumpxml ${VM})
  # Ram in KB. But should grab 'memory unit' and support all possible
  mem=$(echo "$xml" | grep 'memory unit' | cut -d\> -f2 | cut -d\< -f1)
  mem_total=$(( mem_total + mem ))
  vcpu=$(echo "$xml" | grep 'vcpu' | cut -d\> -f2 | cut -d\< -f1)
  vcpu_total=$(( vcpu_total + vcpu ))
  echo "VM=$VM, vCPU=$vcpu, RAM=$mem"
done
echo "VM Total Allocations: vCPU=${vcpu_total}, Memory= ${mem_total}"
#
# Hardware Info
#
cores=$(grep ^processor /proc/cpuinfo | wc -l)
# Ram in KB
ram=$(grep ^MemTotal: /proc/meminfo | awk '{ print $2" "$3 }')
echo "Hardware totals: Cores=${cores}, RAM=${ram}"
#
# Oversubscription Info
#
vcpu_sub=$(perl -e "print $vcpu_total / $cores" )
mem_sub=$(perl -e "print $mem_total / $( echo $ram | cut -d\  -f1 )" )
echo "Subscription: CPU=$(printf '%06.3f' ${vcpu_sub}), Memory=$(printf '%06.3f' ${mem_sub})"

df -h / /home
