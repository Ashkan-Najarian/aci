variable "credentials" {
  type = map(string)
  default = {
    apic_username = "admin"
    apic_password = "C1sco12345"
    apic_url      = "https://10.10.20.14"
  }
  sensitive = true
}

variable "tenant" {
    type    = string
    default = "terraform-tenant"
}
variable "vrf" {
    type    = string
    default = "prod_vrf"
}
variable "bd" {
    type    = string
    default = "prod_bd"
}
variable "subnet" {
    type    = string
    default = "10.10.101.1/24"
}

variable "filters" {
  description = "Create filters with these names and ports"
  type        = map
  default     = {
    filter_https = {
      filter   = "https",
      entry    = "https",
      protocol = "tcp",
      port     = "443"
    },
    filter_sql = {
      filter   = "sql",
      entry    = "sql",
      protocol = "tcp",
      port     = "1433"
    }
  }
}

variable "contracts" {
  description = "Create contracts with these filters"
  type        = map
  default     = {
    contract_web = {
      contract = "web",
      subject  = "https",
      filter   = "filter_https"
    },
    contract_sql = {
      contract = "sql",
      subject  = "sql",
      filter   = "filter_sql"
    }
  }
}

variable "ap" {
    type    = string
    default = "terafform_ap"
}

variable "epgs" {
    description = "Create epg"
    type        = map
    default     = {
        web_epg = {
            epg   = "web",
            bd    = "prod_bd",
            encap = "21"
        },
        db_epg = {
            epg   = "db",
            bd    = "prod_bd",
            encap = "22"
        }
    }
}
variable "epg_contracts" {
    description = "epg contracts"
    type        = map
    default     = {
        terraform_one = {
            epg           = "web_epg",
            contract      = "contract_web",
            contract_type = "provider" 
        },
        terraform_two = {
            epg           = "web_epg",
            contract      = "contract_sql",
            contract_type = "consumer" 
        },
        terraform_three = {
            epg           = "db_epg",
            contract      = "contract_sql",
            contract_type = "provider" 
        }
    }
}