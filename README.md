# Kubeadm Bootstrap

This is a thin layer over Jeff Geerling's excellent Ansible playbooks (https://github.com/geerlingguy/ansible-role-kubernetes).
It uses Terraform to spin up the nodes and an Ansible dynamic inventory. 

Other helper functions in the Makefile create a local installation of python, ansible and terraform 
and pass necessary variables to the Galaxy role. 

There are other ways to do this, such as running a kubeadm container, but this repo is intended
to demonstrate the setup.

![Generated Inventory](https://github.com/kwanlowe/kubeadm-bootstrap/blob/master/kubeadm.png?raw=true)


## Setup


