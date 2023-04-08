resource "aci_tenant" "terraform" {
  name        = "terraform"
  description = "from terraform"
}

# Define an ACI Tenant VRF Resource.
resource "aci_vrf" "terraform_vrf" {
    tenant_dn   = aci_tenant.terraform.id
    description = "VRF Created Using Terraform"
    name        = var.vrf
}

# Define an ACI Tenant BD Resource
resource "aci_bridge_domain" "terraform_bd" {
    tenant_dn          = aci_tenant.terraform.id
    relation_fv_rs_ctx = aci_vrf.terraform_vrf.id
    description        = "BD Created Using Terraform"
    name               = var.bd
}

# Define an ACI Tenant BD Subnet Resource.
resource "aci_subnet" "terraform_bd_subnet" {
    parent_dn   = aci_bridge_domain.terraform_bd.id
    description = "Subnet Created Using Terraform"
    ip          = var.subnet
    scope       = ["public"]
}

# Define an ACI filter Resource.
  resource "aci_filter" "terraform_filter" {
      for_each    = var.filters
      tenant_dn   = aci_tenant.terraform.id
      description = "This is filter ${each.key} created by terraform"
      name        = each.value.filter
}

# Define an ACI filter entry resource.
  resource "aci_filter_entry" "terraform_filter_entry" {
      for_each      = var.filters
      filter_dn     = aci_filter.terraform_filter[each.key].id
      name          = each.value.entry
      ether_t       = "ipv4"
      prot          = each.value.protocol
      d_from_port   = each.value.port
      d_to_port     = each.value.port
}

# Define an ACI Contract Resource.
resource "aci_contract" "terraform_contract" {
    for_each      = var.contracts
    tenant_dn     = aci_tenant.terraform.id
    name          = each.value.contract
    description   = "Contract created using Terraform"
    scope         = "context"
}

# Define an ACI Contract Subject Resource.
resource "aci_contract_subject" "terraform_contract_subject" {
    for_each                      = var.contracts
    contract_dn                   = aci_contract.terraform_contract[each.key].id
    name                          = each.value.subject
    relation_vz_rs_subj_filt_att  = [aci_filter.terraform_filter[each.value.filter].id]
}

# Define an ACI Application Profile Resource.
resource "aci_application_profile" "terraform_ap" {
  tenant_dn  = aci_tenant.terraform.id
  name       = var.ap
  description = "App Profile Created Using Terraform"
}

# Define an ACI Application Policy group.
resource "aci_application_epg" "terraform_epg" {
    for_each                = var.epgs
    application_profile_dn  = aci_application_profile.terraform_ap.id
    name                    = each.value.epg
    relation_fv_rs_bd       = aci_bridge_domain.terraform_bd.id
    description             = "EPG Created Using Terraform"
}

# Associate the EPG Resources with a VMM Domain.
resource "aci_epg_to_domain" "terraform_epg_domain" {
  for_each              = var.epgs
  application_epg_dn    = aci_application_epg.terraform_epg[each.key].id
  provider_profile_dn   = "uni/vmmp-VMware/dom-aci_terraform_lab"
}




