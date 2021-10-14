/**

    $ VDB, v.2.1 2021/10/11 08:14 Exp @di $

    CLI___
          openstack project create --description 'vDB' vdb --domain default
          openstack user create --project vdb --password {password} vdb
          openstack role add --project vdb --user {user} --user-domain default member
          openstack role add --project vdb --user {user} --user-domain default admin

    ENV___
          export TF_VAR_os_auth_url={os_auth_url}
          export TF_VAR_os_tenant_name={os_tenant_name}
          export TF_VAR_os_user_name={os_user_name}
          export TF_VAR_os_password={os_password}
          export TF_VAR_os_region={os_region}

          export TF_VAR_nbx_server_url={url}
          export TF_VAR_nbx_api_token={api_token}
          export TF_VAR_nbx_allow_insecure_https=false

          export TF_VAR_dns_server_url={url}
          export TF_VAR_dns_api_key={api_token}

    CFG___
          variable "os_auth_url" {}
          variable "os_tenant_name" {}
          variable "os_user_name" {}
          variable "os_password" {}
          variable "os_region" {}

          variable "nbx_server_url" {}
          variable "nbx_api_token" {}
          variable "nbx_allow_insecure_https" {}

          variable "dns_server_url" {}
          variable "dns_api_key" {}

          variable "consul_host" { default = "consul.openlabs.vspace307.io" }
          variable "consul_port" { default = 8500 }
          variable "consul_schema" { default = "http" }

          locals {
            consul_url = "${var.consul_schema}://${var.consul_host}:${var.consul_port}"
          }

          provider "openstack" {
            auth_url    = var.os_auth_url
            tenant_name = var.os_tenant_name
            user_name   = var.os_user_name
            password    = var.os_password
            region      = var.os_region
          }

          provider "netbox" {
            server_url           = var.nbx_server_url
            api_token            = var.nbx_api_token
            allow_insecure_https = var.nbx_allow_insecure_https
          }

          provider "powerdns" {
            server_url  = var.dns_server_url
            api_key     = var.dns_api_key
          }

          provider "consul" {
            address    = local.consul_url
            datacenter = var.consul_dc
          }
**/

//
// PROVIDER
//
terraform {
  required_version = ">= 0.14.0"
  required_providers {
    openstack = {
      source  = "terraform-provider-openstack/openstack"
      version = "~> 1.35.0"
    }
    netbox = {
      source = "e-breuninger/netbox"
      version = "0.2.2"
    }
    powerdns = {
      source = "ag-TJNII/powerdns"
      version = "101.6.1"
    }
    consul = {
      source = "hashicorp/consul"
      version = "2.13.0"
    }
  }
}

//
// CORE
//
variable "env" {}
variable "service" {}
variable "project" {}

variable "site_ams" { default = "AMS1" }
variable "site_ldn" { default = "LDN1" }

variable "image" { default = "debian-10" }

variable "flavor_vdb_master" {}
variable "flavor_vdb_slave" {}
variable "flavor_vdb_delay" {}
variable "flavor_vdb_sysbench" {}

variable "router_ams" {}
variable "router_ldn" {}

variable "net_ams_vdb_master" {}
variable "net_ams_vdb_slave" {}
variable "net_ldn_vdb_delay" {}

variable "subnet_ams_vdb_master" {}
variable "subnet_ams_vdb_slave" {}
variable "subnet_ldn_vdb_delay" {}

variable "vm_vdb_master" { default = "master" }
variable "vm_vdb_slave0" { default = "slave0" }
variable "vm_vdb_slave1" { default = "slave1" }
variable "vm_vdb_delay0" { default = "delay0" }
variable "vm_vdb_delay1" { default = "delay1" }
variable "vm_vdb_delay2" { default = "delay2" }
variable "vm_vdb_sysbench" { default = "sysbench" }

variable "volume_type_master" {}
variable "volume_type_slave" {}
variable "volume_type_delay" {}
variable "volume_type_sysbench" {}

variable "disk_boot_size" {}
variable "disk_data_size_master" {}
variable "disk_data_size_slave" {}
variable "disk_data_size_delay" {}

variable "dns_ip" { default = ["172.21.17.17"] }

variable "mgmt_user" {}
variable "mgmt_public_key" {}
variable "mgmt_private_key" {}

// consul
variable "consul_host" {}
variable "consul_port" {}
variable "consul_schema" {}
variable "consul_dc" {}

// role
variable "role_master" { default = "master" }
variable "role_slave" { default = "slave" }
variable "role_delay" { default = "delay" }

//
// VDB
// ---------------------------------------------------------------------------------------------------------------------
variable "vdb_data_dev" { default = "vdb" }
variable "vdb_data_dir" { default = "/data" }

variable "vdb_dir" { default = "/data/db" }
variable "vdb_log" { default = "/data/log" }
variable "vdb_log_bin" { default = "/data/log/mysql-bin.log" }
variable "vdb_log_relay" { default = "/data/log/mysql-relay.log" }
variable "vdb_mgmt_user" {}
variable "vdb_mgmt_password" {}
variable "vdb_root_password" {}

variable "vdb_sysbench" {}
variable "vdb_replica_user" { default = "replica" }
variable "vdb_sysbench_user" { default = "sysbench" }
variable "vdb_sysbench_db" { default = "sysbench" }

variable "vdb_innodb_flush_log_at_trx_commit" {}
variable "vdb_innodb_file_per_table" {}
variable "vdb_innodb_log_file_size" {}
variable "vdb_innodb_buffer_pool_size" {}

variable "vdb_delay_0" { default = "3600" }
variable "vdb_delay_1" { default = "7200" }
variable "vdb_delay_2" { default = "10800" }

variable "vdb_meta" {}
variable "vdb_meta_data_url" {}
variable "vdb_meta_client_url" {}

// sysbench
variable "sysbench_tables" { default = 100 }
variable "sysbench_table_size" { default = 1000 }
variable "sysbench_time" { default = 60 }

// qa
variable "qa_url" { default = "http://qa.infra.vspace307.io" }

// netbox & dns
variable "netbox_cluster" { default = "demo-lab" }
variable "netbox_vm_interface_0" { default = "eth0" }
variable "dns_domain" { default = "cloud.vspace307.io" }

locals {
  key = "key-${var.env}-${var.project}-${var.service}"
  security_group = "sg-${var.env}-${var.project}-${var.service}"
  server_group_anti_affinity = "sg-anti-${var.env}-${var.project}-${var.service}"
  server_group_affinity = "sg-${var.env}-${var.project}-${var.service}"
}

// ansible
variable "vdb_ansible_playbook_master" { default = "master.yaml" }
variable "vdb_ansible_playbook_slave" { default = "slave.yaml" }
variable "vdb_ansible_playbook_delay" { default = "delay.yaml" }
variable "vdb_ansible_playbook_sysbench" { default = "sysbench.yaml" }


// Passwd & UUID
resource "random_password" "vdb_replica_password" {
  length = 36
  special = true
  override_special = "_%@"
}

resource "random_password" "vdb_replica_sysbench" {
  length = 36
  special = true
  override_special = "_%@"
}

resource "random_uuid" "qa" {}

locals {
  qa_uuid = random_uuid.qa.result
  vdb_sysbench_password = random_password.vdb_replica_password.result
  vdb_replica_password = random_password.vdb_replica_sysbench.result
}

// OpenStack
data "openstack_images_image_v2" "vdb" {
  name        = var.image
  most_recent = true
}

data "openstack_compute_flavor_v2" "vdb_master" {
  name = var.flavor_vdb_master
}

data "openstack_compute_flavor_v2" "vdb_slave" {
  name = var.flavor_vdb_slave
}

data "openstack_compute_flavor_v2" "vdb_delay" {
  name = var.flavor_vdb_delay
}

data "openstack_compute_flavor_v2" "vdb_sysbench" {
  name = var.flavor_vdb_sysbench
}

resource "openstack_compute_keypair_v2" "vdb" {
  name       = local.key
  public_key = file(var.mgmt_public_key)
}

resource "openstack_compute_secgroup_v2" "vdb" {
  name        = local.security_group
  description = "open input for VDB"
  rule {
    from_port   = 22
    to_port     = 22
    ip_protocol = "tcp"
    cidr        = "0.0.0.0/0"
  }
  rule {
    from_port   = 3306
    to_port     = 3306
    ip_protocol = "tcp"
    cidr        = "0.0.0.0/0"
  }
}

resource "openstack_compute_servergroup_v2" "vdb_anti_affinity" {
  name     = local.server_group_anti_affinity
  policies = ["anti-affinity"]
}

resource "openstack_compute_servergroup_v2" "vdb_affinity" {
  name     = local.server_group_affinity
  policies = ["affinity"]
}


//
// KV
//
resource "consul_key_prefix" "config" {
  path_prefix = "${var.project}/${var.env}/${var.service}/"

  subkeys = {
    vdb_root_password = var.vdb_root_password

    vdb_mgmt_user = var.vdb_mgmt_user
    vdb_mgmt_password = var.vdb_mgmt_password

    vdb_replica_user = var.vdb_replica_user
    vdb_replica_password = local.vdb_replica_password

    vdb_sysbench = var.vdb_sysbench
    vdb_sysbench_user = var.vdb_sysbench_user
    vdb_sysbench_password = local.vdb_sysbench_password
    vdb_sysbench_db = var.vdb_sysbench_db

    vdb_data_dev = var.vdb_data_dev
    vdb_data_dir = var.vdb_data_dir

    vdb_dir = var.vdb_dir
    vdb_log = var.vdb_log
    vdb_log_bin = var.vdb_log_bin
    vdb_log_relay = var.vdb_log_relay

    qa_url = var.qa_url
    qu_uuid = local.qa_uuid

    vdb_innodb_flush_log_at_trx_commit = var.vdb_innodb_flush_log_at_trx_commit
    vdb_innodb_file_per_table = var.vdb_innodb_file_per_table
    vdb_innodb_log_file_size = var.vdb_innodb_log_file_size
    vdb_innodb_buffer_pool_size = var.vdb_innodb_buffer_pool_size

    vdb_master_ip = module.nbx_vm_vdb_master.vm_ip

    vdb_meta = var.vdb_meta
    vdb_meta_data_url = var.vdb_meta_data_url
    vdb_meta_client_url = var.vdb_meta_client_url

    sysbench_tables = var.sysbench_tables
    sysbench_table_size = var.sysbench_table_size
    sysbench_time = var.sysbench_time

  }
}


//
// AMS
//

// master
module "vdb_master" {
  source = "github.com/di-starss/vspace307-vdb-instance-db"

  env = var.env
  project = var.project
  service = var.service

  role = var.role_master

  instance_name = module.nbx_vm_vdb_master.vm_hostname
  site = module.nbx_vm_vdb_master.site

  server_group = openstack_compute_servergroup_v2.vdb_affinity.id

  flavor = data.openstack_compute_flavor_v2.vdb_master.id
  image = data.openstack_images_image_v2.vdb.id
  key = openstack_compute_keypair_v2.vdb.id

  consul_host = var.consul_host
  consul_port = var.consul_port
  consul_schema = var.consul_schema

  volume = var.volume_type_master
  disk_boot_size = 10
  disk_data_size = 100

  ip = module.nbx_vm_vdb_master.vm_ip
  net = var.net_ams_vdb_master
  security_group = openstack_compute_secgroup_v2.vdb.id

  mgmt_private_key = var.mgmt_private_key
  mgmt_user = var.mgmt_user
  ansible_playbook = var.vdb_ansible_playbook_master

  vdb_id = 1
}

// slave0
module "vdb_slave0" {
  source = "github.com/di-starss/vspace307-vdb-instance-db"
  depends_on = [ module.vdb_master ]

  env = var.env
  project = var.project
  service = var.service

  role = var.role_slave

  instance_name = module.nbx_vm_vdb_slave0.vm_hostname
  site = module.nbx_vm_vdb_slave0.site

  server_group = openstack_compute_servergroup_v2.vdb_anti_affinity.id

  flavor = data.openstack_compute_flavor_v2.vdb_slave.id
  image = data.openstack_images_image_v2.vdb.id
  key = openstack_compute_keypair_v2.vdb.id

  consul_host = var.consul_host
  consul_port = var.consul_port
  consul_schema = var.consul_schema

  volume = var.volume_type_slave
  disk_boot_size = var.disk_boot_size
  disk_data_size = var.disk_data_size_slave

  ip = module.nbx_vm_vdb_slave0.vm_ip
  net = var.net_ams_vdb_slave
  security_group = openstack_compute_secgroup_v2.vdb.id

  mgmt_private_key = var.mgmt_private_key
  mgmt_user = var.mgmt_user
  ansible_playbook = var.vdb_ansible_playbook_slave

  vdb_id = 10
}

// slave1
module "vdb_slave1" {
  source = "github.com/di-starss/vspace307-vdb-instance-db"
  depends_on = [ module.vdb_master ]

  env = var.env
  project = var.project
  service = var.service

  role = var.role_slave

  instance_name = module.nbx_vm_vdb_slave1.vm_hostname
  site = module.nbx_vm_vdb_slave1.site

  server_group = openstack_compute_servergroup_v2.vdb_anti_affinity.id

  flavor = data.openstack_compute_flavor_v2.vdb_slave.id
  image = data.openstack_images_image_v2.vdb.id
  key = openstack_compute_keypair_v2.vdb.id

  consul_host = var.consul_host
  consul_port = var.consul_port
  consul_schema = var.consul_schema

  volume = var.volume_type_slave
  disk_boot_size = var.disk_boot_size
  disk_data_size = var.disk_data_size_slave

  ip = module.nbx_vm_vdb_slave1.vm_ip
  net = var.net_ams_vdb_slave
  security_group = openstack_compute_secgroup_v2.vdb.id

  mgmt_private_key = var.mgmt_private_key
  mgmt_user = var.mgmt_user
  ansible_playbook = var.vdb_ansible_playbook_slave

  vdb_id = 11
}

// delay0
module "vdb_delay0" {
  source = "github.com/di-starss/vspace307-vdb-instance-db"
  depends_on = [ module.vdb_master ]

  env = var.env
  project = var.project
  service = var.service

  role = var.role_delay

  instance_name = module.nbx_vm_vdb_delay0.vm_hostname
  site = var.site_ldn

  server_group = openstack_compute_servergroup_v2.vdb_anti_affinity.id

  flavor = data.openstack_compute_flavor_v2.vdb_delay.id
  image = data.openstack_images_image_v2.vdb.id
  key = openstack_compute_keypair_v2.vdb.id

  consul_host = var.consul_host
  consul_port = var.consul_port
  consul_schema = var.consul_schema

  volume = var.volume_type_delay
  disk_boot_size = var.disk_boot_size
  disk_data_size = var.disk_data_size_delay

  ip = module.nbx_vm_vdb_delay0.vm_ip
  net = var.net_ldn_vdb_delay
  security_group = openstack_compute_secgroup_v2.vdb.id

  mgmt_private_key = var.mgmt_private_key
  mgmt_user = var.mgmt_user
  ansible_playbook = var.vdb_ansible_playbook_delay

  vdb_id = 30
  vdb_delay = var.vdb_delay_0
}

// delay1
module "vdb_delay1" {
  source = "github.com/di-starss/vspace307-vdb-instance-db"
  depends_on = [ module.vdb_master ]

  env = var.env
  project = var.project
  service = var.service

  role = var.role_delay

  instance_name = module.nbx_vm_vdb_delay1.vm_hostname
  site = var.site_ldn

  server_group = openstack_compute_servergroup_v2.vdb_anti_affinity.id

  flavor = data.openstack_compute_flavor_v2.vdb_delay.id
  image = data.openstack_images_image_v2.vdb.id
  key = openstack_compute_keypair_v2.vdb.id

  consul_host = var.consul_host
  consul_port = var.consul_port
  consul_schema = var.consul_schema

  volume = var.volume_type_delay
  disk_boot_size = var.disk_boot_size
  disk_data_size = var.disk_data_size_delay

  ip = module.nbx_vm_vdb_delay1.vm_ip
  net = var.net_ldn_vdb_delay
  security_group = openstack_compute_secgroup_v2.vdb.id

  mgmt_private_key = var.mgmt_private_key
  mgmt_user = var.mgmt_user
  ansible_playbook = var.vdb_ansible_playbook_delay

  vdb_id = 31
  vdb_delay = var.vdb_delay_1
}

// delay2
module "vdb_delay2" {
  source = "github.com/di-starss/vspace307-vdb-instance-db"
  depends_on = [ module.vdb_master ]

  env = var.env
  project = var.project
  service = var.service

  role = var.role_delay

  instance_name = module.nbx_vm_vdb_delay2.vm_hostname
  site = var.site_ldn

  server_group = openstack_compute_servergroup_v2.vdb_anti_affinity.id

  flavor = data.openstack_compute_flavor_v2.vdb_delay.id
  image = data.openstack_images_image_v2.vdb.id
  key = openstack_compute_keypair_v2.vdb.id

  consul_host = var.consul_host
  consul_port = var.consul_port
  consul_schema = var.consul_schema

  volume = var.volume_type_delay
  disk_boot_size = var.disk_boot_size
  disk_data_size = var.disk_data_size_delay

  ip = module.nbx_vm_vdb_delay2.vm_ip
  net = var.net_ldn_vdb_delay
  security_group = openstack_compute_secgroup_v2.vdb.id

  mgmt_private_key = var.mgmt_private_key
  mgmt_user = var.mgmt_user
  ansible_playbook = var.vdb_ansible_playbook_delay

  vdb_id = 32
  vdb_delay = var.vdb_delay_2
}

module "vdb_sysbench" {
  source = "github.com/di-starss/vspace307-vdb-instance-sysbench"
  depends_on = [
    module.vdb_master,
    module.vdb_slave0,
    module.vdb_delay0
  ]

  env = var.env
  project = var.project
  service = var.service

  instance_name = module.nbx_vm_vdb_sysbench.vm_hostname
  site = module.nbx_vm_vdb_sysbench.site

  server_group = openstack_compute_servergroup_v2.vdb_affinity.id

  flavor = data.openstack_compute_flavor_v2.vdb_sysbench.id
  image = data.openstack_images_image_v2.vdb.id
  key = openstack_compute_keypair_v2.vdb.id

  consul_host = var.consul_host
  consul_port = var.consul_port
  consul_schema = var.consul_schema

  volume = var.volume_type_sysbench
  disk_boot_size = 10

  ip = module.nbx_vm_vdb_sysbench.vm_ip
  net = var.net_ams_vdb_master
  security_group = openstack_compute_secgroup_v2.vdb.id

  mgmt_private_key = var.mgmt_private_key
  mgmt_user = var.mgmt_user
  ansible_playbook = var.vdb_ansible_playbook_sysbench
}
