# django-todo-infra
This repository hosts the Infrastructure for Django [todo app](https://github.com/anurag-rajawat/django-todo)

The goal is to define the infrastructure in code for our app using [Terraform](https://www.terraform.io) for AWS

# AWS Services used
- EC2 instance
- RDS with mysql engine
- S3 bucket as shared storage to store the state file
- DynamoDB for locking

# Requirements
- ✅ EC2 instances should be accessible anywhere on the internet via HTTP
- ❌ Only you should be able to access the EC2 instances via SSH
- ✅ RDS should be on a private subnet and inaccessible via the internet
- ✅ Only the EC2 instances should be able to communicate with RDS

# 🚀 Getting started
### 1. Deploy the Infrastructure
  - Configure AWS credentials
  - Configure S3 as shared storage to store the state files
    1. Create S3 bucket and dynamodb table
      ```shell
      $ cd global/s3
      $ terraform init
      $ terraform apply
      ```
    2. Uncomment the backend block in [main.tf](global/s3/main.tf) and configure S3 as shared storage
      ```shell
      $ terraform init
      ```
  - Create the remaining resources
      ```shell
      $ cd ../../prod/
      $ terraform init
      $ terraform apply
      ```
  - Take a note of `db_address` `web_server_public_dns` because these will be used to configure server
### 2. Configure Server to run app
  - Clone the configuration repo
    ```shell
    $ git clone https://github.com/anurag-rajawat/django-todo-configs
    ```
  - Change directory
    ```shell
    $ cd django-todo-configs/
    ```
  - Update `ansible_host` and DB details respectively in `inventory/hosts` and `.env` files (Use `web_server_public_dns` and `db_address` noted earlier)


  - Execute docker playbook to install docker on instance
    ```shell
    $ ansible-playbook playbooks/docker.yml
    ```
  - Execute app playbook to start app on instance
    ```shell
    $ ansible-playbook playbooks/app.yml
    ```
  - Open `http://<server_public_ip_address>` in your favorite browser

### 3. Destroy the infrastructure
  - Change directory to `prod`
    ```shell
    $ cd prod/
    ```
  - Destroy resources
    ```shell
    $ terraform destroy
    ```
  - Change directory to `global/s3`
    ```shell
    $ cd ../global/s3
    ```
  - Unconfigure S3 as backend by commenting the `backend` block in [main.tf](global/s3/main.tf) file
    ```shell
    $ terraform init -migrate-state
    ```
  - Destroy the resources
    ```shell
    $ terraform destroy
    ```
