variable "region" {
  default = "eu-west-3"
}

variable "owner" {
  default = "dgasparina"
}

variable "keyname" {
  default = "damien-paris"
}

variable "ownershort" {
  default = "dga"
}

variable "instance_type" {
  default = "t2.medium"
}

variable "broker-count" {
  default = 3
}

variable "key-file" {
  default = "/home/gaspar_d/.ssh/damien-paris.pem"
}

module "grafana" {
  source     = "./grafana"
  region     = "${var.region}"
  owner      = "${var.owner}"
  ownershort = "${var.ownershort}"
  key-file   = "${var.key-file}"
  key-name   = "${var.keyname}"
}

module "kafka-cluster" {
  source       = "./confluent"
  broker-count = "${var.broker-count}"
  name         = "cluster"
  region       = "${var.region}"
  owner        = "${var.owner}"
  ownershort   = "${var.ownershort}"
  key-file     = "${var.key-file}"
  key-name     = "${var.keyname}"
  influx-host  = "${module.grafana.influxdb_public_dns}"
}

output "kafka-brokers-public-dns" {
  value = ["${module.kafka-cluster.broker_public_dns}"]
}

output "kafka-driver-public-dns" {
  value = ["${module.kafka-cluster.driver_drivers_dns}"]
}

output "grafana-public-dns" {
  value = "${module.grafana.influxdb_public_dns}"
}

output "grafana-url" {
  value = "http://${module.grafana.influxdb_public_dns}:3000"
}