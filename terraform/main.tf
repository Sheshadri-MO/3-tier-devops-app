resource "null_resource" "vm1" {

  triggers = {
    vm_name = "terraform-vm-1"
  }

  provisioner "local-exec" {
    interpreter = ["/bin/bash", "-c"]

    command = <<EOT
# Create VM only if not exists
VBoxManage list vms | grep "terraform-vm-1" || VBoxManage createvm --name terraform-vm-1 --register

# Modify VM
VBoxManage modifyvm terraform-vm-1 --memory 2048 --cpus 2 --nic1 hostonly --hostonlyadapter1 vboxnet0

# Create disk only if not exists
[ -f "$HOME/VirtualBox VMs/terraform-vm-1/terraform-vm-1.vdi" ] || VBoxManage createmedium disk --filename "$HOME/VirtualBox VMs/terraform-vm-1/terraform-vm-1.vdi" --size 20000

# Add storage controller (ignore if exists)
VBoxManage storagectl terraform-vm-1 --name "SATA Controller" --add sata --controller IntelAhci 2>/dev/null || true

# Attach disk
VBoxManage storageattach terraform-vm-1 --storagectl "SATA Controller" --port 0 --device 0 --type hdd --medium "$HOME/VirtualBox VMs/terraform-vm-1/terraform-vm-1.vdi"

# Add IDE controller (ignore if exists)
VBoxManage storagectl terraform-vm-1 --name "IDE Controller" --add ide 2>/dev/null || true

# Attach ISO (force reuse)
VBoxManage storageattach terraform-vm-1 --storagectl "IDE Controller" --port 0 --device 0 --type dvddrive --medium "/Users/sheshadrim/Downloads/ubuntu22server.iso" || true
EOT
  }
}

# ---------------- VM2 ----------------

resource "null_resource" "vm2" {

  triggers = {
    vm_name = "terraform-vm-2"
  }

  provisioner "local-exec" {
    interpreter = ["/bin/bash", "-c"]

    command = <<EOT
# Create VM only if not exists
VBoxManage list vms | grep "terraform-vm-2" || VBoxManage createvm --name terraform-vm-2 --register

# Modify VM
VBoxManage modifyvm terraform-vm-2 --memory 2048 --cpus 2 --nic1 hostonly --hostonlyadapter1 vboxnet0

# Create disk only if not exists
[ -f "$HOME/VirtualBox VMs/terraform-vm-2/terraform-vm-2.vdi" ] || VBoxManage createmedium disk --filename "$HOME/VirtualBox VMs/terraform-vm-2/terraform-vm-2.vdi" --size 20000

# Add storage controller
VBoxManage storagectl terraform-vm-2 --name "SATA Controller" --add sata --controller IntelAhci 2>/dev/null || true

# Attach disk
VBoxManage storageattach terraform-vm-2 --storagectl "SATA Controller" --port 0 --device 0 --type hdd --medium "$HOME/VirtualBox VMs/terraform-vm-2/terraform-vm-2.vdi"

# Add IDE controller
VBoxManage storagectl terraform-vm-2 --name "IDE Controller" --add ide 2>/dev/null || true

# Attach ISO (avoid duplicate error)
VBoxManage storageattach terraform-vm-2 --storagectl "IDE Controller" --port 0 --device 0 --type dvddrive --medium "/Users/sheshadrim/Downloads/ubuntu22server.iso" || true
EOT
  }
}

resource "null_resource" "monitoring_vm" {

  triggers = {
    vm_name = "monitoring-vm"
  }

  provisioner "local-exec" {
    interpreter = ["/bin/bash", "-c"]

    command = <<EOT
# Create VM only if not exists
VBoxManage list vms | grep "monitoring-vm" || VBoxManage createvm --name monitoring-vm --register

# Modify VM (less resources needed)
VBoxManage modifyvm monitoring-vm --memory 1024 --cpus 1 --nic1 hostonly --hostonlyadapter1 vboxnet0

# Create disk only if not exists
[ -f "$HOME/VirtualBox VMs/monitoring-vm/monitoring-vm.vdi" ] || VBoxManage createmedium disk --filename "$HOME/VirtualBox VMs/monitoring-vm/monitoring-vm.vdi" --size 15000

# Add storage controller
VBoxManage storagectl monitoring-vm --name "SATA Controller" --add sata --controller IntelAhci 2>/dev/null || true

# Attach disk
VBoxManage storageattach monitoring-vm --storagectl "SATA Controller" --port 0 --device 0 --type hdd --medium "$HOME/VirtualBox VMs/monitoring-vm/monitoring-vm.vdi"

# Add IDE controller
VBoxManage storagectl monitoring-vm --name "IDE Controller" --add ide 2>/dev/null || true

# Attach ISO
VBoxManage storageattach monitoring-vm --storagectl "IDE Controller" --port 0 --device 0 --type dvddrive --medium "/Users/sheshadrim/Downloads/ubuntu22server.iso" || true
EOT
  }
}

resource "null_resource" "loadbalancer_vm" {

  triggers = {
    vm_name = "loadbalancer-vm"
  }

  provisioner "local-exec" {
    interpreter = ["/bin/bash", "-c"]

    command = <<EOT
# Create VM only if not exists
VBoxManage list vms | grep "loadbalancer-vm" || VBoxManage createvm --name loadbalancer-vm --register

# Modify VM (LB needs moderate resources)
VBoxManage modifyvm loadbalancer-vm --memory 1024 --cpus 1 --nic1 hostonly --hostonlyadapter1 vboxnet0

# Create disk only if not exists
[ -f "$HOME/VirtualBox VMs/loadbalancer-vm/loadbalancer-vm.vdi" ] || VBoxManage createmedium disk --filename "$HOME/VirtualBox VMs/loadbalancer-vm/loadbalancer-vm.vdi" --size 15000

# Add storage controller
VBoxManage storagectl loadbalancer-vm --name "SATA Controller" --add sata --controller IntelAhci 2>/dev/null || true

# Attach disk
VBoxManage storageattach loadbalancer-vm --storagectl "SATA Controller" --port 0 --device 0 --type hdd --medium "$HOME/VirtualBox VMs/loadbalancer-vm/loadbalancer-vm.vdi"

# Add IDE controller
VBoxManage storagectl loadbalancer-vm --name "IDE Controller" --add ide 2>/dev/null || true

# Attach ISO
VBoxManage storageattach loadbalancer-vm --storagectl "IDE Controller" --port 0 --device 0 --type dvddrive --medium "/Users/sheshadrim/Downloads/ubuntu22server.iso" || true
EOT
  }
}

resource "null_resource" "redis_vm" {

  triggers = {
    vm_name = "redis-vm"
  }

  provisioner "local-exec" {
    interpreter = ["/bin/bash", "-c"]

    command = <<EOT
# Create VM only if not exists
VBoxManage list vms | grep "redis-vm" || VBoxManage createvm --name redis-vm --register

# Modify VM (Redis needs more RAM, single CPU is fine)
VBoxManage modifyvm redis-vm --memory 2048 --cpus 1 --nic1 hostonly --hostonlyadapter1 vboxnet0

# Create disk only if not exists
[ -f "$HOME/VirtualBox VMs/redis-vm/redis-vm.vdi" ] || VBoxManage createmedium disk --filename "$HOME/VirtualBox VMs/redis-vm/redis-vm.vdi" --size 10000

# Add storage controller
VBoxManage storagectl redis-vm --name "SATA Controller" --add sata --controller IntelAhci 2>/dev/null || true

# Attach disk
VBoxManage storageattach redis-vm --storagectl "SATA Controller" --port 0 --device 0 --type hdd --medium "$HOME/VirtualBox VMs/redis-vm/redis-vm.vdi"

# Add IDE controller
VBoxManage storagectl redis-vm --name "IDE Controller" --add ide 2>/dev/null || true

# Attach ISO
VBoxManage storageattach redis-vm --storagectl "IDE Controller" --port 0 --device 0 --type dvddrive --medium "/Users/sheshadrim/Downloads/ubuntu22server.iso" || true
EOT
  }
}