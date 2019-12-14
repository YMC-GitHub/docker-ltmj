#!/bin/sh

THIS_FILE_PATH=$(
    cd $(dirname $0)
    pwd
)
source $THIS_FILE_PATH/function-list.sh
source $THIS_FILE_PATH/config.sh
THIS_PROJECT_PATH=$(path_resolve "$THIS_FILE_PATH" "../")
RUN_SCRIPT_PATH=$(pwd)

function add_mysql() {
    local author=
    local email=
    local TXT=
    author=ymc-github
    email=yemiancheng@gmail.com
    local TXT=
    TXT=$(
        cat <<EOF
######
# See: https://github.com/YMC-GitHub/mirror-mysql
######

# data serve with mysql
#FROM registry.cn-hangzhou.aliyuncs.com/yemiancheng/mysql:alpine-3.10.3
#FROM mariadb:10.1.13
#FROM mariadb:10.2.30
FROM mariadb:$MYSQL_VERSION
#FROM mariadb:10.3.21
#FROM mariadb:10.4.11
LABEL MAINTAINER ymc-github <yemiancheng@gmail.com>
#EXPOSE 3306
#set timezone
#uses local pm time with -v /etc/localtime:/etc/localtime in compose file
#RUN apk add -U tzdata &&  cp "/usr/share/zoneinfo/Asia/Shanghai" "/etc/localtime" && apk del tzdata
#COPY \$(pwd)/mysql/conf/my.cnf /etc/mysql/my.cnf
#https://mariadb.com/kb/en/library/system-variable-differences-between-mariadb-and-mysql/
#https://hub.docker.com/_/mariadb
#https://blog.csdn.net/dongdong9223/article/details/86645690
# get the relation with mysql and mariadb
# mysql -V
EOF
    )
    TXT=$(echo "$TXT" | sed "s/^ *#.*//g" | sed "/^$/d")
    echo "$TXT"
}

function add_tomcat() {
    local author=
    local email=
    local TXT=
    author=ymc-github
    email=yemiancheng@gmail.com
    local TXT=
    TXT=$(
        cat <<EOF
######
# See: https://hub.docker.com/_/tomcat
######
# web serve with tomcat
#FROM tomcat:8.5.41-jre8-alpine
FROM tomcat:${TOMCAT_VERSION}-alpine
LABEL MAINTAINER ymc-github <yemiancheng@gmail.com>
#https://hub.docker.com/_/tomcat?tab=tags&page=1&name=alpine
#https://hub.docker.com/_/openjdk?tab=tags&page=1&name=8-jdk-alpine
#https://hub.docker.com/_/openjdk?tab=tags&page=1&name=8-jre-alpine
EOF
    )
    TXT=$(echo "$TXT" | sed "s/^ *#.*//g" | sed "/^$/d")
    echo "$TXT"
}

function add_redis() {
    local author=
    local email=
    local TXT=
    author=ymc-github
    email=yemiancheng@gmail.com
    local TXT=
    TXT=$(
        cat <<EOF
######
# See: https://hub.docker.com/_/redis
######
# data serve with redis
#https://hub.docker.com/_/redis?tab=tags&page=1&name=alpine
FROM redis:${REDIS_VERSION}-alpine3.10
LABEL MAINTAINER ymc-github <yemiancheng@gmail.com>
#COPY redis-master/conf/redis.conf /usr/local/etc/redis/redis.conf
CMD [ "redis-server", "/usr/local/etc/redis/redis.conf" ]
EOF
    )
    TXT=$(echo "$TXT" | sed "s/^ *#.*//g" | sed "/^$/d")
    echo "$TXT"
}
function add_activemq() {
    local author=
    local email=
    local TXT=
    author=ymc-github
    email=yemiancheng@gmail.com
    local TXT=
    TXT=$(
        cat <<EOF
######
# See: https://hub.docker.com/r/rmohr/activemq
######
# https://hub.docker.com/r/rmohr/activemq
FROM rmohr/activemq:${ACTIVEMQ_VERSION}-alpine
LABEL MAINTAINER ymc-github <yemiancheng@gmail.com>

EOF
    )
    TXT=$(echo "$TXT" | sed "s/^ *#.*//g" | sed "/^$/d")
    echo "$TXT"
}

function main_fun() {
    local path=
    local TXT=

    path="$THIS_PROJECT_PATH/mysql/Dockerfile"
    echo "gen Dockerfile :$path"
    TXT=$(add_mysql)
    TXT=$(echo "$TXT" | sed "s/^ *#.*//g" | sed "/^$/d")
    echo "$TXT" >"$path"

    path="$THIS_PROJECT_PATH/redis-master/Dockerfile"
    echo "gen Dockerfile :$path"
    TXT=$(add_redis)
    TXT=$(echo "$TXT" | sed "s/^ *#.*//g" | sed "/^$/d")
    echo "$TXT" >"$path"
    path="$THIS_PROJECT_PATH/redis-slave/Dockerfile"
    echo "gen Dockerfile :$path"
    TXT=$(add_redis)
    TXT=$(echo "$TXT" | sed "s/^ *#.*//g" | sed "/^$/d")
    echo "$TXT" >"$path"

    path="$THIS_PROJECT_PATH/tomcat/Dockerfile"
    echo "gen Dockerfile :$path"
    TXT=$(add_tomcat)
    TXT=$(echo "$TXT" | sed "s/^ *#.*//g" | sed "/^$/d")
    echo "$TXT" >"$path"

    path="$THIS_PROJECT_PATH/activemq/Dockerfile"
    echo "gen Dockerfile :$path"
    TXT=$(add_activemq)
    TXT=$(echo "$TXT" | sed "s/^ *#.*//g" | sed "/^$/d")
    echo "$TXT" >"$path"
}
main_fun

#### usage
#./tool/gen-dockerfile.sh
