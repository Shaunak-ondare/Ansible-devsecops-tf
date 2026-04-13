# Ansible Architecture & Concepts

This document details the Ansible concepts, configurations, and patterns implemented in this repository. It provides a comprehensive overview of how Ansible is used to automate infrastructure configuration for a hybrid environment containing both Linux and Windows nodes.

> [!NOTE]
> The Ansible structure in this repository follows best practices by separating concerns into environments (inventory), global configurations (`ansible.cfg`), orchestration (`playbook.yml`), and reusable components (`roles`).

## 1. Inventory Management (`inventory.ini`)

Ansible needs to know what hosts it manages. This is defined in `inventory.ini`.

```ini
[linux]
linux_host ansible_host=LINUX_IP_HERE ansible_user=ubuntu ansible_ssh_private_key_file=/home/ubuntu/id_rsa

[windows]
windows_host ansible_host=WINDOWS_IP_HERE ansible_user=Administrator ansible_password="{{ lookup('env', 'WINDOWS_PASSWORD') }}" ansible_connection=winrm ansible_winrm_server_cert_validation=ignore
```

**Concepts Implemented:**
- **Host Groups**: Hosts are organized into logical groups (`[linux]` and `[windows]`), allowing you to target specific subsets of infrastructure.
- **Connection Variables**: Defines how Ansible connects to each host.
  - *Linux*: Uses SSH standard keys (`ansible_ssh_private_key_file`).
  - *Windows*: Uses WinRM (`ansible_connection=winrm`) instead of SSH, which is the standard methodology for Windows remote management.
- **Dynamic Lookups**: `ansible_password="{{ lookup('env', 'WINDOWS_PASSWORD') }}"` demonstrates the `lookup` plugin, which dynamically fetches the password from the Controller's environment variables (useful for CI/CD security, preventing hardcoded credentials).

## 2. Global Configuration (`ansible.cfg`)

The `ansible.cfg` file applies base behaviors to the Ansible runtime.

```ini
[defaults]
inventory = inventory.ini
host_key_checking = False
retry_files_enabled = False
```

**Concepts Implemented:**
- **Host Key Checking**: Disabled to prevent interactive prompts for new SSH connections (essential for automated CI/CD pipelines).
- **Inventory Path**: Hardcoded to `inventory.ini` so it doesn't need to be passed via `-i` on the CLI continually.

## 3. Playbooks and Privilege Escalation (`playbook.yml`)

The playbook is the entry point that maps hosts to their configuration roles.

```yaml
- name: Configure Linux Server
  hosts: linux
  become: yes
  collections:
    - ansible.builtin
  roles:
    - linux_stack

- name: Configure Windows Server
  hosts: windows
  become: no
  collections:
    - ansible.windows
    - community.windows
  roles:
    - windows_stack
```

**Concepts Implemented:**
- **Plays**: Two distinct plays targeting different host groups (`hosts: linux` and `hosts: windows`).
- **Privilege Escalation (`become`)**: 
  - On Linux, `become: yes` uses `sudo` to gain root privileges needed for installing packages like NGINX and MySQL.
  - On Windows, `become: no` is used, as the connection is already authenticated as the `Administrator` user.
- **Collections Declarations**: Explicitly stating which Ansible Galaxy collections are required for the play ensures clarity and avoids module resolution errors.

## 4. Roles and Reusable Configuration

Roles allow you to break down complex playbooks into modular, reusable components. This repository uses two roles: `linux_stack` and `windows_stack`.

### `linux_stack` Role
Focuses on provisioning open-source data and web server stacks.

**Concepts Implemented:**
- **Package Management (`apt`)**: Uses `update_cache` and idempotently installs software (`state: present`).
- **Looping (`loop`)**: Iterates over a list of items (`[gnupg, curl]`) to run the same task multiple times efficiently.
- **Repository Management (`apt_key`, `apt_repository`)**: Securely adds 3rd-party GPG keys and custom external repository sources before installing packages (seen with MongoDB).
- **Service Management (`service`)**: Ensures daemons are `started` and `enabled` to start on boot automatically.

### `windows_stack` Role
Focuses on provisioning IIS and deploying a .NET 8.0 application.

**Concepts Implemented:**
- **Windows Feature Installation (`ansible.windows.win_feature`)**: Installs native OS features like the IIS `Web-Server`.
- **Filesystem Management (`win_file`, `win_copy`)**: Creates directories and copies compiled release artifacts (`app_dist/`) from the controller to the target node.
- **Web Download and Installation (`win_get_url`, `win_package`)**: Downloads the `.NET 8.0 Hosting Bundle` directly from Microsoft and silently installs it using MSI/EXE arguments.
- **IIS Management (`community.windows.win_iis_webapppool`, `win_iis_website`)**: Idempotently manages application pools and websites, routing port 80 to the physical path holding the `.NET` application.
- **Command Execution (`win_shell`)**: Invokes arbitrary commands on the target (`iisreset` to apply runtime changes).

## 5. Idempotency

Throughout both roles, Ansible's core concept of **idempotency** is strongly utilized. Tasks declare the *desired state* (`state: present`, `state: directory`, `state: started`) rather than giving imperative commands. If the resource is already in that state, Ansible makes no changes and reports "ok" instead of "changed".
