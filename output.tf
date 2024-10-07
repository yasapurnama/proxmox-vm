output "vim_ids" {
  value = proxmox_vm_qemu.default[*].id
}

output "vm_names" {
  value = proxmox_vm_qemu.default[*].name
}

output "vm_states" {
  value = proxmox_vm_qemu.default[*].vm_state
}

output "vm_ip_addresses" {
  value = proxmox_vm_qemu.default[*].default_ipv4_address
}

output "vm_ciusers" {
  value = proxmox_vm_qemu.default[*].ciuser
}

output "vm_ssh_hosts" {
  value = proxmox_vm_qemu.default[*].ssh_host
}

output "vm_ssh_ports" {
  value = proxmox_vm_qemu.default[*].ssh_port
}