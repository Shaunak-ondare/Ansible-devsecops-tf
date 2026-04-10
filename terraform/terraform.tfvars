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

# --- Security (Managed via GitHub Secrets) ---
# Note: ssh_public_key is handled in the CI/CD pipeline.
# If running locally, you can uncomment and add it here:
# ssh_public_key = "ssh-rsa YOUR_KEY_HERE"
