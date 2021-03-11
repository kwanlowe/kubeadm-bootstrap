# Kubeadm Bootstrap

This is a thin layer over Jeff Geerling's excellent Ansible playbooks (https://github.com/geerlingguy/ansible-role-kubernetes).
It uses Terraform to spin up the nodes and an Ansible dynamic inventory. 

Other helper functions in the Makefile create a local installation of python, ansible and terraform 
and pass necessary variables to the Galaxy role. 

There are other ways to do this, such as running a kubeadm container, but this repo is intended
to demonstrate the setup.

![Generated Inventory](https://github.com/kwanlowe/kubeadm-bootstrap/blob/master/kubeadm.png?raw=true)


## Setup

The Makefile contains functions to install Terraform, GCP and a Python virtual environment. To set this up:

    git clone https://github.com/kwanlowe/kubeadm-bootstrap.git
    cd kubeadm-bootstrap
    make install-google-cloud-sdk
    make install-python-tools
    make install terraform
    source setup.env

Your prompt should change to reflect the new environment.  To test:

    which python
    which terraform
    which gcloud

These should all return paths located in the ```kubeadm-bootstrap``` directory.

Next, set the ```GOOGLE_APPLICATION_CREDENTIALS``` environment variable to the location of your GCP credentials.:

    export GOOGLE_APPLICATION_CREDENTIALS=~/path/to/projectname.json


## Configure Ansible

Generate the Ansible dynamic inventory file by running the following:

    make generate-ansible-inventory PROJECT=<project name> GCP_CREDS=/path/to/projectname.json 

For example:

    make generate-ansible-inventory PROJECT=myproject GCP_CREDS=~/.ssh/myproject_train_123456.json

This will create an ```inventory/hosts.gcp.yml``` file that will be used in subsequent commands. 
Once the inventory is generated, test with:

    make list-ansible-inventory

The command should return a list of resource in the GCP account, sorted by tags.

Next, install the playbooks for Docker and Kubernetes:

    make install-ansible-roles

Test the configuration:

    make test-ansible


## Deploy

Deploy the inventory (build the Virtual Machines) and ingrastructure:

    make terraform-init
    make infrasctructure-gcp

Deploy the playbook:
	
    make deploy

