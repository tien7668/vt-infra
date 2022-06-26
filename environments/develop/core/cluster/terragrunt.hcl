locals {
  shared_vars = yamldecode(file(find_in_parent_folders("shared/variables.yaml")))
}

include "root" {
  path = find_in_parent_folders()
}

terraform {
  source = "git::git@github.com:KyberNetwork/terraform-modules.git//gcp/cluster?ref=gcp-cluster-v0.1.8"
}

inputs = {
  project_id   = local.shared_vars.projects.develop
  cluster_name = "core-cluster"   

  region = local.shared_vars.region
  zones  = local.shared_vars.zones

  vpc_name    = "core-network"
  subnet_name = "core-cluster-subnet"

  ip_range_pods     = "pod-range"
  ip_range_services = "service-range"

  created_service_account = true
  enabled_kes             = true
}


users = [
  {
    cluster_role = true
    email        = "tien7668@gmail.com"
    kind         = "user"
    namespace    = ""
    rules = [{
      api_groups = [""]
      resources  = ["*"]
      verbs      = ["*"]
    }]
  }
]
node_pools = [
  {
    name               = "medium-pool"
    machine_type       = "e2-medium"
    min_count          = 2
    max_count          = 4
    disk_size_gb       = 100
    disk_type          = "pd-standard"
    image_type         = "COS"
    auto_repair        = true
    auto_upgrade       = true
    preemptible        = true
    node_locations     = join(",", local.shared_vars.zones)
    initial_node_count = 1 # 1 node / zone
  },
]