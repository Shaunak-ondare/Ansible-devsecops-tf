# 🚀 Ansible-devsecops-tf: Hybrid Hybrid Cloud Infrastructure CI/CD

This project demonstrates a fully automated, secure, and multi-cloud-ready infrastructure deployment. It combines **Terraform** for infrastructure as code, **Ansible** for configuration management, and a robust **GitHub Actions** CI/CD pipeline integrated with **Snyk** and **SonarCloud**.

## 🏗️ Architecture Overview

The pipeline provisions a hybrid environment on AWS:
*   **Linux Host**: Ubuntu server running a standard stack (**Nginx**, **MySQL**, **MongoDB**).
*   **Windows Host**: Windows Server 2022 running **IIS** and a modern **ASP.NET Core 8.0** web application.
*   **Networking**: Modular VPC with Public and Private subnets, NAT Gateway, and secure Routing.

## 🛠️ Tech Stack

*   **IaC**: Terraform (Modular)
*   **Config Mgmt**: Ansible (WinRM & SSH)
*   **CI/CD**: GitHub Actions
*   **Security**: Snyk (SCA & IaC scanning)
*   **Quality**: SonarCloud (Static Analysis with Code Coverage)
*   **App**: .NET 8.0 MVC (Glassmorphism UI)

---

## 🚀 How it Works (Pipeline Flow)

1.  **Build & Quality Gate**: The .NET app is compiled and unit tests are run via xUnit. Code coverage is collected and sent to SonarCloud. If the Quality Gate fails, the pipeline stops.
2.  **Security Audit**: Snyk scans the application dependencies and Terraform manifests for vulnerabilities.
3.  **Infrastructure Orchestration**: Terraform provisions the VPC and EC2 instances using S3 for state management and native S3 locking.
4.  **Auto-Configuration**: Ansible connects to the new instances using captured IPs and the secrets provided, bootstrapping both environments.

---

## 🛠️ Setup Guide

### 1. AWS Pre-requisites
*   Create an **S3 Bucket** for Terraform state.
*   (Optional) If using Terraform < 1.10, create a **DynamoDB table** for locking. For TF 1.10+, native S3 locking is used (`use_lockfile = true`).
*   Create an IAM User with `AdministratorAccess` (or scoped permissions) and save the Access/Secret keys.

### 2. Configure GitHub Secrets
Navigate to your Repo **Settings > Secrets and variables > Actions** and add:

| Secret Name | Description |
| :--- | :--- |
| `AWS_ACCESS_KEY_ID` | Your AWS Access Key |
| `AWS_SECRET_ACCESS_KEY` | Your AWS Secret Key |
| `SNYK_TOKEN` | API Token from [Snyk](https://snyk.io/) |
| `SONAR_TOKEN` | Analysis Token from [SonarCloud](https://sonarcloud.io/) |
| `SONAR_ORGANIZATION` | Your SonarCloud Org Key |
| `SSH_PUBLIC_KEY` | The public key for EC2 instances |
| `SSH_PRIVATE_KEY` | The private key for Ansible SSH connection |
| `WINDOWS_PASSWORD` | Administrator password for Windows EC2 |

### 3. Local Configuration
1.  **Backend**: Update `terraform/backend.tf` with your bucket name.
2.  **Variables**: Update `terraform/terraform.tfvars` with your desired CIDR blocks and instance types.
3.  **SonarCloud**: Ensure the project and organization keys in `deploy.yml` match your dashboard.

### 4. Run the Pipeline
Once you push your changes to the `main` branch (or trigger manually via `workflow_dispatch`), the pipeline will handle the rest!

---

## 📂 Project Structure

```text
├── .github/workflows/  # CI/CD Pipeline
├── DotNetApp/          # ASP.NET Core Web Application
├── DotNetApp.Tests/    # Unit Tests & Coverage
├── ansible/            # Playbooks & Roles
│   ├── roles/          # Linux & Windows specific configurations
├── terraform/          # Modular IaC
│   ├── modules/        # VPC and Compute modules
```

---

## 📜 License
This project is open-source and available under the MIT License.
