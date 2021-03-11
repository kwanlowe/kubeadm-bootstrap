PROJECT=myproject
GCP_CREDS=~/path/to/google_application_creds.json
VENV=python_venv
ROLES_PATH=roles
TF_BINARY_URL=https://releases.hashicorp.com/terraform/0.14.7/terraform_0.14.7_linux_amd64.zip
GCP_BINARY_URL=https://dl.google.com/dl/cloudsdk/channels/rapid/downloads/google-cloud-sdk-330.0.0-linux-x86_64.tar.gz
SCRATCH=tmp
BINPATH=bin
TFDIR=tf/nodes
PRIVKEY=~/.ssh/google_compute_engine
INVENTORY_DIR=inventory
ANSIBLE_INVENTORY=$(INVENTORY_DIR)/hosts.gcp.yml


help:
	@grep '^[a-z].*:$$' Makefile|tr -d ':'

install-google-cloud-sdk:
	mkdir -p $(SCRATCH) $(BINPATH)
	wget -P tmp/ $(GCP_BINARY_URL)
	@$(eval GCP_BASENAME=$(shell sh -c "basename $(GCP_BINARY_URL)"))
	tar xf $(SCRATCH)/$(GCP_BASENAME) -C $(SCRATCH)/
	mv $(SCRATCH)/google-cloud-sdk $(BINPATH)
	
install-python-tools:
	virtualenv -p $$(which python3) $(VENV)
	$(VENV)/bin/pip install -r requirements.txt
	mkdir -p $(ROLES_PATH)

install-terraform:
	mkdir -p $(SCRATCH) $(BINPATH)
	wget -P tmp/ $(TF_BINARY_URL)
	@$(eval TF_BASENAME=$(shell sh -c "basename $(TF_BINARY_URL)"))
	unzip -p $(SCRATCH)/$(TF_BASENAME) terraform >./$(BINPATH)/terraform
	chmod +x bin/terraform

generate-ansible-inventory:
	mkdir -p $(INVENTORY_DIR)
	m4 -DPROJECT=$(PROJECT) -DKEYFILE=$(GCP_CREDS) inventory_template.gcp.yml_m4 > $(ANSIBLE_INVENTORY)

list-ansible-inventory:
	@ansible-inventory --list

install-ansible-roles:
	mkdir -p roles
	ansible-galaxy install --roles-path $(ROLES) geerlingguy.docker geerlinguy.kubernetes

test-ansible:
	ansible all -m ping --key-file=$(PRIVKEY)

terraform-init:
	cd $(TFDIR) && terraform init

infrastructure-gcp:
	@ $(eval CLIENT_EXTERNAL_IP=$(shell sh -c "curl ifconfig.me 2>/dev/null"))
	cd $(TFDIR) && terraform apply -var="client_external_ip=$(CLIENT_EXTERNAL_IP)/32"

deploy:
	ansible-playbook --become --become-user root --flush-cache --key-file=~$(PRIVKEY)  playbooks/deploy.yml


