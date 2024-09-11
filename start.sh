#!/bin/bash

# Start SSH service
/usr/sbin/sshd

# Start Jupyter Lab
jupyter lab --ip=0.0.0.0 --allow-root --no-browser &

# Start code-server
code-server --auth none --bind-addr 0.0.0.0:8080 &

# Start NGINX
nginx

# Run pre-start script
/pre_start.sh

# Keep the container running
tail -f /dev/null