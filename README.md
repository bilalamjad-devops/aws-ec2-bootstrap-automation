

# Automating AWS EC2 Server Provisioning and Configuration with Terraform & Ansible

## Provision Infrastructure as Code and Eliminate Manual Server Configuration

---

# Introduction

Provisioning cloud infrastructure is only the first step in deploying an application. Every newly created server still requires configuration before it is ready for use. Installing packages, creating users, configuring services, and preparing the operating system manually is repetitive, time-consuming, and prone to human error.

Modern DevOps practices separate these responsibilities into two stages:

* **Infrastructure Provisioning** – Creating cloud resources.
* **Configuration Management** – Preparing those resources for application deployment.

In this project, we will use **Terraform** to provision AWS EC2 instances and **Ansible** to automatically configure them. By the end, every newly created server will be consistently configured and ready for application deployment without repetitive manual work.

---

# Business Problem

Imagine a company launches new EC2 instances every week for development, testing, or production.

Without automation, a DevOps engineer must manually:

* Connect to each server using SSH.
* Install Git.
* Install Docker.
* Install Nginx.
* Create Linux users.
* Configure sudo permissions.
* Configure the firewall.
* Verify that services are running correctly.

While these tasks are simple, repeating them for every server wastes valuable engineering time and increases the risk of configuration drift, where servers no longer share the same configuration.

As the infrastructure grows, maintaining consistency becomes increasingly difficult.

---

# Solution

This project automates the complete server bootstrap process by combining Infrastructure as Code with Configuration Management.

The workflow is straightforward:

* **Terraform** provisions AWS infrastructure.
* **Ansible** connects to the newly created servers through SSH.
* **Ansible Playbooks** install software, configure the operating system, and prepare each server for application deployment.

Instead of configuring every server manually, engineers only execute Terraform and Ansible, allowing the entire environment to be built in a repeatable and consistent manner.

---

# What You Will Build

After completing this project, you will have:

* One AWS EC2 instance acting as the Ansible Control Node.
* Two AWS EC2 instances acting as Managed Nodes.
* A reusable Terraform configuration.
* An Ansible inventory.
* An Ansible playbook that configures multiple servers simultaneously.

---

# Project Architecture

```text
                    Developer
                         │
                         ▼
                Terraform Apply
                         │
                         ▼
                  AWS Infrastructure
                         │
        ┌────────────────┴────────────────┐
        │                                 │
        ▼                                 ▼
 Ansible Control Node              Managed Node 1
                                   Managed Node 2
                         │
                         ▼
                  Ansible Playbook
                         │
        ├── Update Packages
        ├── Install Git
        ├── Install Docker
        ├── Install Nginx
        ├── Create Linux User
        ├── Configure Firewall
        └── Verify Services
```

---

# Prerequisites

Before starting, make sure you have the following:

* AWS Account
* AWS CLI installed and configured
* Terraform installed
* Ansible installed on the Control Node
* SSH Key Pair
* Basic Linux knowledge

---

# Project Structure

```text
aws-ec2-bootstrap-automation/

├── terraform/
│   ├── main.tf
│   ├── variables.tf
│   ├── outputs.tf
│   └── terraform.tfvars
│
├── ansible/
│   ├── hosts.ini
│   ├── site.yml
│   └── ansible.cfg
│
├── app/
│   └── index.html
│
└── README.md
```

---

# Step 1 — Provision AWS Infrastructure with Terraform

In this step, Terraform provisions the required AWS resources.

The infrastructure includes:

* AWS Key Pair
* Security Group
* One Ansible Control Node
* Two Managed Nodes
* Output values for the instance IP addresses

Run the following commands:

```bash
terraform init

terraform plan

terraform apply
```

After the deployment completes successfully, Terraform outputs the IP addresses of the created EC2 instances.

---

# Step 2 — Install and Configure Ansible

SSH into the Control Node and install Ansible.

After installation, verify the version and ensure Ansible is functioning correctly.

Next, create an inventory file that contains the managed nodes.

Example:

```ini
[webservers]
web01 ansible_host=<private_ip_1> ansible_user=ubuntu
web02 ansible_host=<private_ip_2> ansible_user=ubuntu
```

Finally, verify SSH connectivity:

```bash
ansible webservers -m ping
```

Both servers should return a successful response.

---

# Step 3 — Configure the Servers Using Ansible

Create an Ansible playbook that performs the following tasks:

* Update the operating system
* Install Git
* Install Docker
* Install Nginx
* Create a developer user
* Configure the firewall
* Deploy a sample web page

Run the playbook:

```bash
ansible-playbook -i hosts.ini site.yml
```

Ansible connects to every managed node, compares the current state with the desired state, and performs only the required changes.

---

# Step 4 — Verification

Verify that the automation completed successfully.

Check the following on each managed node:

* Git is installed.
* Docker is installed.
* Nginx is running.
* The developer user exists.
* The sample web page is accessible through the browser.

If all checks pass, the bootstrap process is complete.

---

# Results

Instead of manually configuring every newly created server, the provisioning and configuration process is now fully automated.

Infrastructure is created consistently using Terraform, while Ansible ensures every server follows the same configuration standard.

This approach reduces manual effort, improves consistency, and provides a repeatable deployment workflow suitable for both learning environments and production-inspired projects.

---

# Conclusion

Terraform and Ansible complement each other exceptionally well.

Terraform focuses on provisioning infrastructure, while Ansible focuses on configuring operating systems and software after the infrastructure exists.

By combining both tools, we can automate the complete lifecycle of server deployment—from creating cloud resources to preparing them for application deployment.

In future improvements, this project can be extended by introducing Ansible Roles, Dynamic Inventory, Packer Golden AMIs, and CI/CD pipelines to build a fully automated infrastructure platform.

I also recommend using a **problem-solving repository name** instead of a tool-based one. My top choices are:

1. `aws-ec2-bootstrap-automation` ⭐ (my favorite)
2. `automated-ec2-server-bootstrap`
3. `aws-server-bootstrap`
4. `standardized-ec2-provisioning`

This article has the potential to become one of your strongest portfolio pieces because it demonstrates a real operational workflow: **provision infrastructure once, configure it consistently every time**. Later, you can naturally publish a follow-up article that adds GitHub Actions to automate the Ansible execution.
