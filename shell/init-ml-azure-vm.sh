sleep 2m

# Update CentOS - It will take quit a while to complete 
#sudo yum -y update

# Init ML bootstrap node
sh init-bootstrap-node.sh 'admin' 'admin' 'basic' \
    3 10 'public' localhost

# Wait for ML to Init
sleep 2m

# Creat datadog user in ML DB
curl -X POST --anyauth --user admin:admin -i -H "Content-Type: application/json" -d '{"user-name": "datadog", "password": "T3m@sek#", "roles": {"role": "manage-user"}}' http://localhost:8002/manage/v2/users    

# Deploy pre-configed datadog yaml files
cp -f /var/lib/waagent/custom-script/download/0/datadog.yaml /etc/datadog-agent/
cp -f /var/lib/waagent/custom-script/download/0/conf.yaml /etc/datadog-agent/config.g/marklogic.d/

# Restart datadog agent
sudo systemctl restart datadog-agent
