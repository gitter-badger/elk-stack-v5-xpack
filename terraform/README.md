# Docker server spinup for ELK workshop

# Spin up stack

```bash
## Clone repozitory:
[root@workstation ]# git clone https://github.com/VAdamec/elk-stack-v5-xpack 

# Run Docker
[root@workstation ]# docker build . -t elk-stack-v5-xpack
[root@workstation ]# docker run -v `pwd`:/code -ti elk-stack-v5-xpack /bin/bash

## Rename sample variables and add your credentials
[root@container /]# cd /code
[root@container code]# mv variables.sample variables.tf
[root@container code]# terraform plan
[root@container code]# terraform apply
```

#### Run cmds in instances via Ansible

```bash
ansible -i ./terraform.py all -m shell -u centos --private-key=<PATH_TO_YOUR_KEY> -b -a "uptime"

# For example add your key
ansible -i ./terraform.py all -m shell -u centos --private-key=~/.ssh/terraform.pem -b -a "echo 'YOURPUBKEY' >> /root/.ssh/authorized_keys"
```

# Remove stack

```bash
## Destroy stack
[root@container code]# terraform destroy
```
