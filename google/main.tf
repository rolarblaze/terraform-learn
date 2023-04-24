terraform {
  required_providers {
    google = {
      source  = "hashicorp/google"
      version = "4.62.1"
    }
  }
}

provider "google" {
  # Configuration options
  credentials = file("terraform-pro.json")
  project     = "terraform-pro-384702"
  region      = "europe-west4"
  zone        = "europe-west4-a"
}

// Since we have successfully created a an instance, we need to create a VPC for 

resource "google_compute_network" "vpc" {
  name                    = "vpc-test-for-vm"
  auto_create_subnetworks = false
  routing_mode            = "GLOBAL"
}

// create a public subnet
resource "google_compute_subnetwork" "pub_subnet" {
  name          = "test-public-subnet-1"
  ip_cidr_range = "10.2.0.0/16"
  network       = google_compute_network.vpc.id
  region        = "europe-west4"

}

resource "google_compute_firewall" "allow_http" {
  name    = "allow-fw-http"
  network = google_compute_network.vpc.id

  allow {
    protocol = "tcp"
    ports    = ["80"]
  }
  target_tags = ["http"]
}

# enable port 443 to allow https traffic 
resource "google_compute_firewall" "allow_https" {
  name    = "allow-fw-https"
  network = google_compute_network.vpc.id
  allow {
    protocol = "tcp"
    ports    = ["443"]
  }
  target_tags = ["https"]
}

# Enable port 22 to allow ssh traffic
resource "google_compute_firewall" "allow-ssh" {
  name    = "${var.app_name}-fw-allow-ssh"
  network = google_compute_network.vpc.id
  allow {
    protocol = "tcp"
    ports    = ["22"]
  }
  target_tags = ["ssh"]
}

# Enable port 3389 to allow rdp traffic
resource "google_compute_firewall" "allow-rdp" {
  name    = "${var.app_name}-fw-allow-ssh"
  network = google_compute_network.vpc.id
  allow {
    protocol = "tcp"
    ports    = ["3389"]
  }
  target_tags = ["rdp"]
}

resource "google_compute_instance" "compute_instance" {
  name         = "server"
  machine_type = "e2-micro"
  zone         = "europe-west4-a"
  hostname     = "testvm-${var.app_domain}"

  tags = ["ssh", "http"]

  boot_disk {
    initialize_params {
      image = "debian-cloud/debian-11"
    }
  }

  # setting up network interface card 
  network_interface {
    network = google_compute_network.vpc.id

    subnetwork = google_compute_subnetwork.pub_subnet.id

    access_config {}
  }
}