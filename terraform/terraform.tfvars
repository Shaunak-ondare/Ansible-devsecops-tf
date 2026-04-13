# --- Project Configuration ---
project_name = "ansible-devsecops-tf"
region       = "ap-south-1"

# --- Networking (Modularized) ---
vpc_cidr            = "10.20.30.0/24"
public_subnet_cidr  = "10.20.30.0/26"
private_subnet_cidr = "10.20.30.64/26"
availability_zone   = "ap-south-1a"

# --- Compute ---
instance_type = "c7i-flex.large"

