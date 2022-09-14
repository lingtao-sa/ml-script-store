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

#------------------------
# Marklogic
#------------------------


# Init ML bootstrap node
sh init-bootstrap-node.sh 'admin' 'lingtao' 'basic' \
    3 10 'public' localhost


# Create ml-backup directory and assign owner to daemon (ML default linux user)
cd /
sudo mkdir ml-backup
sudo chown -R daemon:daemon /ml-backup    

# Wait for ML to Init DB
sleep 2m

#------------------------
# Datadog
#------------------------

# Creat datadog user in ML DB
curl -X POST --anyauth --user admin:lingtao -i -H "Content-Type: application/json" -d '{"user-name": "datadog", "password": "T3m@sek#", "roles": {"role": "manage-user"}}' http://localhost:8002/manage/v2/users    

# Deploy pre-configed datadog yaml files
yes | cp /var/lib/waagent/custom-script/download/0/datadog.yaml /etc/datadog-agent/
yes | cp /var/lib/waagent/custom-script/download/0/conf.yaml /etc/datadog-agent/conf.d/marklogic.d/

chown dd-agent:dd-agent /etc/datadog-agent/conf.d/marklogic.d/conf.yaml
chmod 744 conf.yaml /etc/datadog-agent/conf.d/marklogic.d/conf.yaml


# Restart datadog agent
sudo systemctl restart datadog-agent
# sudo systemctl status datadog-agent


#------------------------
# Sumo Logic 
#------------------------

# Downlaod Sumo Logic Collector
wget "https://collectors.sumologic.com/rest/download/linux/64" -O SumoCollector.sh && chmod +x SumoCollector.sh

# Deploy pre-configed sumologic source file
yes | cp /var/lib/waagent/custom-script/download/0/ml-azure-centos-sources.json /ml-backup
yes | mv ./SumoCollector.sh /ml-backup

# Install Sumo Logic Collector
sudo /ml-backup/SumoCollector.sh -q -Vsumo.accessid=suFrhPnrF9D0P1 -Vsumo.accesskey=yN2Kuy1915Du6uHmdWeHCMDcVAulN0F2cbHACmVDluzBmcjdx3eJL6NZeqpKfhbF -VsyncSources=/ml-backup/ml-azure-centos-sources.json -Vcollector.name="TAO DEV Collector"

# Start Sumo Logic Collector
sudo service collector start
# sudo ./collector start
