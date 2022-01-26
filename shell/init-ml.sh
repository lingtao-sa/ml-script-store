# Wait for ML to start
sleep 3m

# Init bootstrap node
sh init-bootstrap-node.sh 'admin' 'admin' 'basic' \
    3 10 'public' localhost
