This repository contains Terraform configurations to manage infrastructure for Martino-CF.

## Overview

The Terraform configurations in this repository are used to provision and manage cloud infrastructure for Martino-CF, including:

- Networking setup
- Compute instances
- Storage resources
- Security configurations

## Prerequisites

Before you begin, ensure you have the following installed:

- [Terraform](https://www.terraform.io/downloads.html) CLI

## Getting Started

To get started with this Terraform configuration:

1. Clone this repository:

   ```bash
   git clone https://github.com/martinoml/Martino-CF.git
   cd Martino-CF/Terraform
   Initialize Terraform:

2. Initializew Terraform
    terraform init

3. Review and modify the terraform modules to desired configuration

4. Plan to see what changes Terraform will apply, run:
     terraform plan

5. To apply the terraform configuration and create/update resources, run:
    terraform apply

6. To destroy all resources created 
