#!/bin/sh

# projet dir construtor
PROJECT_DIR_CONSTRUTOR=$(
    cat <<EOF
#nodejs=nodejs
mysql=mysql
#mongo=mongo
redis-master=redis-master
redis-slave=redis-slave
tomcat=tomcat
maven=maven
activemq=activemq
EOF
)

#db_driver=mongo
MYSQL_VERSION=10.3.15
REDIS_VERSION=5.0.7
TOMCAT_VERSION=8.5.41
ACTIVEMQ_VERSION=5.14.3
MAVEN_VERSION=3.6.1
JAVA_VERSION=
#os
OS=alpine

#todo:gen by func
CM_MYSQL_NAME="mysql-${MYSQL_VERSION}-${OS}"
CM_REDIS_NAME="redis-${REDIS_VERSION}-${OS}"
CM_TOMCAT_NAME="tomcat-${TOMCAT_VERSION}-${OS}"
CM_ACTIVEMQ_NAME="activemq-${ACTIVEMQ_VERSION}-${OS}"
