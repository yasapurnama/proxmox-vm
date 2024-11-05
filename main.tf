resource "proxmox_vm_qemu" "default" {
  count = var.vm_count
  name  = "${var.name}-${count.index}"

  target_node = var.target_node
  clone       = var.os_template
  os_type     = var.os_type
  agent       = var.agent

  define_connection_info = true
  ipconfig0 = var.ip_dhcp ? "ip=dhcp" : "ip=${var.ip_network_id}.${var.ip_network_host + count.index}/24,gw=${var.ip_gateway}"
  nameserver = var.ip_dhcp ? "" : var.ip_dns_nameserver

  vcpus    = var.vcpus
  cores    = var.cpu_cores
  sockets  = var.cpu_socket
  memory   = var.memory
  hotplug  = var.hotplug
  scsihw   = var.scsihw
  bootdisk = var.bootdisk
  onboot   = var.onboot


  network {
    model    = var.network_model
    bridge   = var.network_bridge
    tag      = var.network_tag
    firewall = var.network_firewall
  }

  disks {
    virtio {
      virtio0 {
        disk {
          size   = var.disk_size
          storage = var.disk_storage
          discard = var.disk_discard
        }
      }
    }
    ide {
      ide2 {
        cloudinit {
          storage = var.disk_storage
        }
      }
    }
  }

  lifecycle {
    ignore_changes = [
      ciuser,
      sshkey
    ]
  }

}
