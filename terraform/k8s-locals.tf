locals {
  # global configurations
  agent        = 1
  cidr         = var.lan_cidr
  onboot       = true
  proxmox_node = "pve"
  scsihw       = "virtio-scsi-pci"
  template     = var.cloudinit_template

  bridge = {
    interface = var.lan_bridge
    model     = "virtio"
  }

  disks = {
    main = {
      backup  = true
      format  = "raw"
      type    = "disk"
      storage = "os"
      slot    = "scsi0"
      discard = true
    }
    cloudinit = {
      backup  = true
      format  = "raw"
      type    = "cloudinit"
      storage = "os"
      slot    = "ide2"
    }
  }
  # # serial is needed to connect via WebGUI console
  serial = {
    id   = 0
    type = "socket"
  }

  # cloud init information to be injected
  cloud_init = {
    user            = "ubuntu"
    password        = "ubuntu"
    ssh_public_key  = file("~/.ssh/id_ed25519.pub")
    ssh_private_key = file("~/.ssh/id_ed25519")
  }

  masters = {
    count = 3

    name_prefix = "k8s-master"
    vmid_prefix = 300

    cores     = 2
    disk_size = "32G" # same or higher size of cloudinit template
    memory    = 3072
    sockets   = 1

    # 192.168.0.7x and so on...
    network_last_octect = 20
    tags                = "masters"
  }

  workers = {
    count = 3

    name_prefix = "k8s-worker"
    vmid_prefix = 400

    cores     = 3
    disk_size = "32G"
    memory    = 4608
    sockets   = 2

    network_last_octect = 30
    tags                = "workers"
  }
}
