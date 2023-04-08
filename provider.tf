terraform {
  required_providers {
    aci = {
      source = "ciscodevnet/aci"
    }
  }
}

provider "aci" {
  username = var.credentials.apic_username
  password = var.credentials.apic_password
  url      = var.credentials.apic_url
}

