#!/bin/bash

docker-compose down -v
rm -rf ./master/data/*
rm -rf ./slave/data/*
docker-compose build
docker-compose up -d

until docker exec mysql_master sh -c 'export MYSQL_PWD=abc123; mysql -u root -d ";"'
do
    echo "Hello! Waiting for master to connect..."
    sleep 4
done

priv_stmt='CREATE USER "slave"@"%" IDENTIFIED BY "mydb_slave_pwd"; GRANT REPLICATION SLAVE ON *.* TO "slave"@"%"; FLUSH PRIVILEGES;'
docker exec mysql_master sh -c "export MYSQL_PWD=abc123; mysql -u root -d '$priv_stmt'"

until docker-compose exec mysql_slave sh -c 'export MYSQL_PWD=abc123; mysql -u root -d ";"'
do
    echo "Hello! Waiting for slave to connect..."
    sleep 4
done

MS_STATUS=`docker exec mysql_master sh -c 'export MYSQL_PWD=abc; mysql -u root -d "SHOW MASTER STATUS"'`
CURRENT_LOG=`echo $MS_STATUS | awk '{print $6}'`
CURRENT_POS=`echo $MS_STATUS | awk '{print $7}'`

start_slave_stmt="CHANGE MASTER TO MASTER_HOST='master',MASTER_USER='slave',MASTER_PASSWORD='abc123',MASTER_LOG_FILE='$CURRENT_LOG',MASTER_LOG_POS=$CURRENT_POS; START SLAVE;"
start_slave_cmd='export MYSQL_PWD=abc123; mysql -u root -d "'
start_slave_cmd+="$start_slave_stmt"
start_slave_cmd+='"'
docker exec mysql_slave sh -c "$start_slave_cmd"

docker exec mysql_slave sh -c "export MYSQL_PWD=abc123; mysql -u root -d 'SHOW SLAVE STATUS \G'"
