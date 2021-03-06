# Copyright 2022-2018 MarkLogic Corporation.  All Rights Reserved.
#
#!/bin/bash
######################################################################################################
# File         : init-ml-azure-vm.sh
# Description  : This script will setup the first node in the cluster
# Usage        : sh init-bootstrap-node.sh username password auth-mode \
#                n-retry retry-interval security-realm hostname
######################################################################################################


# Wait for ML to start
sleep 2m

# Update CentOS - It will take quit a while to complete 
sudo yum -y update

# Init ML bootstrap node
sh init-bootstrap-node.sh 'admin' 'lingtao' 'basic' \
    3 10 'public' localhost

# Wait for ML to init database
sleep 2m

# Creat datadog user in ML DB
curl -X POST --anyauth --user admin:admin -i -H "Content-Type: application/json" -d '{"user-name": "datadog", "password": "T3m@sek#", "roles": {"role": "manage-user"}}' http://localhost:8002/manage/v2/users    

# Deploy pre-configed datadog yaml files
yes | cp /var/lib/waagent/custom-script/download/0/datadog.yaml /etc/datadog-agent/
yes | cp /var/lib/waagent/custom-script/download/0/conf.yaml /etc/datadog-agent/conf.d/marklogic.d/

chown dd-agent:dd-agent /etc/datadog-agent/conf.d/marklogic.d/conf.yaml
chmod 744 conf.yaml /etc/datadog-agent/conf.d/marklogic.d/conf.yaml


# Restart datadog agent
sudo systemctl restart datadog-agent
# sudo systemctl status datadog-agent
