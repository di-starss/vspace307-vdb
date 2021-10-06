//
// Host (Netbox & DNS)
//

// master
module "nbx_vm_vdb_master" {
  source = "github.com/di-starss/vspace307-cloud-netbox"

  env = var.env
  project = var.project
  service = var.service
  site = var.site_ams
  domain = var.dns_domain

  cluster = var.netbox_cluster
  vm_name = var.vm_vdb_master
  vm_interface = var.netbox_vm_interface_0
  prefix = var.subnet_ams_vdb_master
}

module "dns_vm_vdb_master" {
  source = "github.com/di-starss/vspace307-cloud-dns-record"

  zone = module.nbx_vm_vdb_master.dns_zone
  record = module.nbx_vm_vdb_master.dns_record
  ip = module.nbx_vm_vdb_master.vm_ip
}

// slave0
module "nbx_vm_vdb_slave0" {
  source = "github.com/di-starss/vspace307-cloud-netbox"

  env = var.env
  project = var.project
  service = var.service
  site = var.site_ams
  domain = var.dns_domain

  cluster = var.netbox_cluster
  vm_name = var.vm_vdb_slave0
  vm_interface = var.netbox_vm_interface_0
  prefix = var.subnet_ams_vdb_slave
}

module "dns_vm_vdb_slave0" {
  source = "github.com/di-starss/vspace307-cloud-dns-record"

  zone = module.nbx_vm_vdb_slave0.dns_zone
  record = module.nbx_vm_vdb_slave0.dns_record
  ip = module.nbx_vm_vdb_slave0.vm_ip
}

// slave1
module "nbx_vm_vdb_slave1" {
  source = "github.com/di-starss/vspace307-cloud-netbox"
  depends_on = [ module.nbx_vm_vdb_slave0 ]

  env = var.env
  project = var.project
  service = var.service
  site = var.site_ams
  domain = var.dns_domain

  cluster = var.netbox_cluster
  vm_name = var.vm_vdb_slave1
  vm_interface = var.netbox_vm_interface_0
  prefix = var.subnet_ams_vdb_slave
}

module "dns_vm_vdb_slave1" {
  source = "github.com/di-starss/vspace307-cloud-dns-record"

  zone = module.nbx_vm_vdb_slave1.dns_zone
  record = module.nbx_vm_vdb_slave1.dns_record
  ip = module.nbx_vm_vdb_slave1.vm_ip
}

// delay0
module "nbx_vm_vdb_delay0" {
  source = "github.com/di-starss/vspace307-cloud-netbox"

  env = var.env
  project = var.project
  service = var.service
  site = var.site_ldn
  domain = var.dns_domain

  cluster = var.netbox_cluster
  vm_name = var.vm_vdb_delay0
  vm_interface = var.netbox_vm_interface_0
  prefix = var.subnet_ldn_vdb_delay
}

module "dns_vm_vdb_delay0" {
  source = "github.com/di-starss/vspace307-cloud-dns-record"

  zone = module.nbx_vm_vdb_delay0.dns_zone
  record = module.nbx_vm_vdb_delay0.dns_record
  ip = module.nbx_vm_vdb_delay0.vm_ip
}

// delay1
module "nbx_vm_vdb_delay1" {
  source = "github.com/di-starss/vspace307-cloud-netbox"
  depends_on = [ module.nbx_vm_vdb_delay0 ]

  env = var.env
  project = var.project
  service = var.service
  site = var.site_ldn
  domain = var.dns_domain

  cluster = var.netbox_cluster
  vm_name = var.vm_vdb_delay1
  vm_interface = var.netbox_vm_interface_0
  prefix = var.subnet_ldn_vdb_delay
}

module "dns_vm_vdb_delay1" {
  source = "github.com/di-starss/vspace307-cloud-dns-record"

  zone = module.nbx_vm_vdb_delay1.dns_zone
  record = module.nbx_vm_vdb_delay1.dns_record
  ip = module.nbx_vm_vdb_delay1.vm_ip
}

// delay2
module "nbx_vm_vdb_delay2" {
  source = "github.com/di-starss/vspace307-cloud-netbox"
  depends_on = [ module.nbx_vm_vdb_delay0, module.nbx_vm_vdb_delay1 ]

  env = var.env
  project = var.project
  service = var.service
  site = var.site_ldn
  domain = var.dns_domain

  cluster = var.netbox_cluster
  vm_name = var.vm_vdb_delay2
  vm_interface = var.netbox_vm_interface_0
  prefix = var.subnet_ldn_vdb_delay
}

module "dns_vm_vdb_delay2" {
  source = "github.com/di-starss/vspace307-cloud-dns-record"

  zone = module.nbx_vm_vdb_delay2.dns_zone
  record = module.nbx_vm_vdb_delay2.dns_record
  ip = module.nbx_vm_vdb_delay2.vm_ip
}

// sysbench
module "nbx_vm_vdb_sysbench" {
  source = "github.com/di-starss/vspace307-cloud-netbox"
  depends_on = [ module.nbx_vm_vdb_master ]

  env = var.env
  project = var.project
  service = var.service
  site = var.site_ams
  domain = var.dns_domain

  cluster = var.netbox_cluster
  vm_name = var.vm_vdb_sysbench
  vm_interface = var.netbox_vm_interface_0
  prefix = var.subnet_ams_vdb_master
}

module "dns_vm_vdb_sysbench" {
  source = "github.com/di-starss/vspace307-cloud-dns-record"

  zone = module.nbx_vm_vdb_sysbench.dns_zone
  record = module.nbx_vm_vdb_sysbench.dns_record
  ip = module.nbx_vm_vdb_sysbench.vm_ip
}
