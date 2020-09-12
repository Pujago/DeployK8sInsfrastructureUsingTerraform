variable client_id {
  description = "Client Id"
}
variable client_secret {
  description = "Client Secret"
}

variable subscription_id {
  description = "Subscription Id"
}

variable tenant_id {
  description = "Tenant Id"
}

variable ssh_public_key {}

variable environment {
  description = "Name of the environment"
  default     = "dev"
}

variable location {
  description = "Name of the Azure location"
  default     = "australiaeast"
}

variable node_count {
  default = 3
}



variable dns_prefix {
  default = "eks"
}

variable cluster_name {
  default = "eks"
}

variable resource_group {
  default = "kubernetes"
}