#!/bin/bash

set -e

source .env

create_service() {

    SERVICE_NAME=$1
    PORT=$2

    echo "Creating $SERVICE_NAME on port $PORT"

    sudo mkdir -p /etc/$SERVICE_NAME
    sudo mkdir -p /var/log/$SERVICE_NAME
    mkdir -p ~/multi-nginx/generated/$SERVICE_NAME  

    export SERVICE_NAME
    export PORT

    envsubst < templates/nginx.conf.template | sudo tee /etc/$SERVICE_NAME/nginx.conf > /dev/null
    envsubst < templates/nginx.conf.template > ~/multi-nginx/generated/$SERVICE_NAME/nginx.conf 

    envsubst < templates/nginx.service.template | sudo tee /etc/systemd/system/$SERVICE_NAME.service > /dev/null
    envsubst < templates/nginx.service.template > ~/multi-nginx/generated/$SERVICE_NAME/$SERVICE_NAME.service 

    sudo systemctl daemon-reload
    sudo systemctl enable $SERVICE_NAME
    sudo systemctl restart $SERVICE_NAME
}

create_service $NGINX1_NAME $NGINX1_PORT
create_service $NGINX2_NAME $NGINX2_PORT

echo "Done!"
