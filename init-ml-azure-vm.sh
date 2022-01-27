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
#sleep 2m

# Update CentOS - It will take quit a while to complete 
sudo yum -y update

# Init ML bootstrap node
sh init-bootstrap-node.sh 'admin' 'admin' 'basic' \
    3 10 'public' localhost