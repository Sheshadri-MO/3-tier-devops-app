output "vm_names" {
  description = "List of Virtual Machines created"
  value = [
    "terraform-vm-1",
    "terraform-vm-2",
    "loadbalancer-vm",
    "monitoring-vm",
    "cache-vm"
  ]
}

output "vm_configuration" {
  description = "Configuration details of all VMs"
  value = {
    app_vm1 = {
      name    = "terraform-vm-1"
      role    = "Application Server"
      memory  = "2048 MB"
      cpus    = 2
      disk    = "20GB"
      network = "hostonly (vboxnet0)"
    }

    app_vm2 = {
      name    = "terraform-vm-2"
      role    = "Application Server (Scaling)"
      memory  = "2048 MB"
      cpus    = 2
      disk    = "20GB"
      network = "hostonly (vboxnet0)"
    }

    load_balancer = {
      name    = "loadbalancer-vm"
      role    = "Nginx Load Balancer"
      memory  = "1024 MB"
      cpus    = 1
      disk    = "15GB"
      network = "hostonly (vboxnet0)"
    }

    monitoring = {
      name    = "monitoring-vm"
      role    = "Monitoring Server (Prometheus + Grafana)"
      memory  = "1024 MB"
      cpus    = 1
      disk    = "15GB"
      network = "hostonly (vboxnet0)"
    }

    cache = {
      name    = "cache-vm"
      role    = "Redis Cache Server"
      memory  = "1024 MB"
      cpus    = 1
      disk    = "10GB"
      network = "hostonly (vboxnet0)"
    }
  }
}

output "iso_used" {
  description = "Ubuntu ISO used for installation"
  value       = "/Users/sheshadrim/Downloads/ubuntu22server.iso"
}

output "verification_commands" {
  description = "Commands to verify VMs in VirtualBox"
  value = {
    list_vms         = "VBoxManage list vms"
    app_vm1_info     = "VBoxManage showvminfo terraform-vm-1"
    app_vm2_info     = "VBoxManage showvminfo terraform-vm-2"
    lb_info          = "VBoxManage showvminfo loadbalancer-vm"
    monitoring_info  = "VBoxManage showvminfo monitoring-vm"
    cache_info       = "VBoxManage showvminfo cache-vm"
  }
}

output "next_steps" {
  description = "Next steps after terraform apply"
  value = [
    "1. Start all VMs",
    "2. Install Ubuntu on all VMs",
    "3. Remove ISO after installation",
    "4. Setup SSH access",
    "5. Run Ansible playbooks",
    "6. Deploy Docker application",
    "7. Configure Load Balancer",
    "8. Setup Redis cache",
    "9. Configure Monitoring (Prometheus + Grafana)"
  ]
}
