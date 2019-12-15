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
    local TXT=
    TXT=$(
        cat <<EOF
# data serve with mysql
  mysql:
    hostname: mysql
    #container_name: mysql-$MYSQL_VERSION
    container_name: ${CM_MYSQL_NAME}
    build: ./mysql
    ports:
      - 3308:3306
    networks:
      staticnymc:
        ipv4_address: 172.20.1.3
    environment:
      MYSQL_ROOT_PASSWORD: yourpassword
      #      MYSQL_DATABASE: xxx
      #      MYSQL_USER: xxx
      #      MYSQL_PASSWORD: xxx123456
      TZ: Asia/Shanghai
      LANG: en_US.UTF-8
    volumes:
      # conf
      - ./mysql/my.cnf:/etc/mysql/my.cnf
      # data
      - ./mysql/data:/app/mysql
      # backup
      - ./mysql/backup:/backup
      # date and time
      - /etc/localtime:/etc/localtime
    restart: always
  #    restart: unless-stopped
EOF
    )
    TXT=$(echo "$TXT" | sed "s/^ *#.*//g" | sed "/^$/d")
    echo "$TXT"
}

function add_tomcat() {
    local TXT=
    TXT=$(
        cat <<EOF
  tomcat:
    # set his host name
    hostname: tomcat
    # only [a-zA-Z0-9][a-zA-Z0-9_.-] are allowed
    #container_name: $CM_TOMCAT_NAME
    container_name: ${CM_TOMCAT_NAME}
    # set the cm  it depends on
    depends_on:
      - mysql
      - redis_master
      - redis_slave
      - activemq
    build: ./tomcat
    # must to be the same with ./tomcat/conf/server.xml
    ports:
      - 8080:8080
    # define your owen network
    networks:
      staticnymc:
        ipv4_address: 172.20.1.2
    #    - 80:80
    #    - 443:443
    # set pm/vm dir path map to cm dir path
    volumes:
      - ./tomcat/conf:/usr/local/tomcat/conf
      - ./tomcat/logs:/usr/local/tomcat/logs
      - /etc/localtime:/etc/localtime
      - ./tomcat/webapps:/usr/local/tomcat/webapps
    # set some env var for cm
    environment:
      JAVA_OPTS: -Dfile.encoding=UTF-8
      TZ: Asia/Shanghai
      LANG: en_US.UTF-8
    # set the start mode of cm for pro
    restart: always
  #    restart: unless-stopped
EOF
    )
    TXT=$(echo "$TXT" | sed "s/^ *#.*//g" | sed "/^$/d")
    echo "$TXT"
}

function add_network() {
    local TXT=
    TXT=$(
        cat <<EOF
networks:
  staticnymc:
    ipam:
      config:
        - subnet: 172.20.1.0/24
          gateway: 172.20.1.1
EOF
    )
    TXT=$(echo "$TXT" | sed "s/^ *#.*//g" | sed "/^$/d")
    echo "$TXT"
}
function add_redis() {
    local TXT=
    TXT=$(
        cat <<EOF
  redis_master:
    hostname: redis-master
    container_name: ${CM_REDIS_NAME}-master
    build: ./redis-master
    ports:
      - 6379:6379
    networks:
      staticnymc:
        ipv4_address: 172.20.1.4
    volumes:
      - ./redis-master/data:/data
      - /etc/localtime:/etc/localtime
      - ./redis-master/conf/redis.conf:/usr/local/etc/redis/redis.conf
      #- ./redis-master/conf/redis.conf:etc/redis/redis.conf
    #command: redis-server /usr/local/etc/redis/redis.conf
    #command: redis-server /etc/redis/redis.conf
    environment:
      TZ: Asia/Shanghai
      LANG: en_US.UTF-8
    restart: always
  redis_slave:
    hostname: redis-slave
    container_name: ${CM_REDIS_NAME}-slave
    build: ./redis-slave
    ports:
      - 6380:6380
    networks:
      staticnymc:
        ipv4_address: 172.20.1.5
    volumes:
      - ./redis-slave/data:/data
      # set your redis confi file ./redis/conf/redis.conf. the default content is as below:
      ### requirepass yourpassword
      ### bind: 0.0.0.0
      ### loglevel notice
      ### logfile "redis.log"
      ### port 6380
      ### masterauth yourpassword
      ### slaveof redis_master 6379
      - /etc/localtime:/etc/localtime
      - ./redis-slave/conf/redis.conf:/usr/local/etc/redis/redis.conf
      #- ./redis-slave/conf/redis.conf:etc/redis/redis.conf
    #command: redis-server /usr/local/etc/redis/redis.conf
    #command: redis-server /etc/redis/redis.conf
    environment:
      TZ: Asia/Shanghai
      LANG: en_US.UTF-8
    restart: always
EOF
    )
    TXT=$(echo "$TXT" | sed "s/^ *#.*//g" | sed "/^$/d")
    echo "$TXT"
}

function add_activemq() {
    local TXT=
    TXT=$(
        cat <<EOF
  activemq:
    hostname: activemq
    container_name: ${CM_ACTIVEMQ_NAME}
    build: ./activemq
    ports:
      - 8161:8161
      - 61616:61616
    # 定义IP网络
    networks:
      staticnymc:
        ipv4_address: 172.20.1.6
    volumes:
      - ./activemq/data:/data/activemq
      - ./activemq/logs:/var/log/activemq
      - /etc/localtime:/etc/localtime
    environment:
      ACTIVEMQ_ADMIN_LOGIN: admin
      ACTIVEMQ_ADMIN_PASSWORD: admin
      ACTIVEMQ_CONFIG_MINMEMORY: 512
      ACTIVEMQ_CONFIG_MAXMEMORY: 2048
      TZ: Asia/Shanghai
      LANG: en_US.UTF-8
    restart: always
EOF
    )
    TXT=$(echo "$TXT" | sed "s/^ *#.*//g" | sed "/^$/d")
    echo "$TXT"
}
function add_nodejs() {
    local TXT=
    TXT=$(
        cat <<EOF
  nodejs:
    hostname: nodejs
    container_name: ${CM_NODEJS_NAME}
    build: ./nodejs
    ports:
      - 3000:3000
    networks:
      staticnymc:
        ipv4_address: 172.20.1.7
    volumes:
      - ./app:/usr/share/nginx/html
      - /etc/localtime:/etc/localtime
    restart: always
    links:
      - mysql:mysql
EOF
    )
    TXT=$(echo "$TXT" | sed "s/^ *#.*//g" | sed "/^$/d")
    echo "$TXT"
}
function add_nginx() {
    local TXT=
    TXT=$(
        cat <<EOF
  nginx:
    hostname: nginx
    container_name: ${CM_NGINX_NAME}
    build: ./nginx
    ports:
      - 80:80
      - 443:443
      - 8080:80
    networks:
      staticnymc:
        ipv4_address: 172.20.1.8
    volumes:
      - ./app:/usr/share/nginx/html
      - ./nginx/nginx.conf:/etc/nginx/nginx.conf:ro
      - ./nginx/conf.d/:/etc/nginx/conf.d/:ro
      - ./nginx/ca/server.crt/:/etc/nginx/server.crt:ro
      - ./nginx/ca/server.key/:/etc/nginx/server.key:ro
      - /etc/localtime:/etc/localtime
    restart: always
    links:
    - tomcat:__DOCKER_TOMCAT__
    - nodejs:__DOCKER_FE_NODEJS__
EOF
    )
    TXT=$(echo "$TXT" | sed "s/^ *#.*//g" | sed "/^$/d")
    echo "$TXT"
}

function main_fun() {
    local name="Ye Miancheng"
    local email="ymc.github@gmail.com"
    local homepage="https://github.com/YMC-GitHub"
    local TXT=
    local nginx_txt=$(add_nginx)
    local nodejs_txt=$(add_nodejs)
    local mysql_txt=$(add_mysql)
    local redis_txt=$(add_redis)
    local network_txt=$(add_network)
    local tomcat_txt=$(add_tomcat)
    local activemq_txt=$(add_activemq)
    TXT=$(
        cat <<EOF
version: '2'
services: 
$mysql_txt
$redis_txt
$tomcat_txt
$activemq_txt
$nodejs_txt
$nginx_txt
$network_txt

EOF
    )
    echo "gen docker-compose.yml :$THIS_PROJECT_PATH/docker-compose.yml"
    TXT=$(echo "$TXT" | sed "s/^ *#.*//g" | sed "/^$/d")
    echo "$TXT" >"$THIS_PROJECT_PATH/docker-compose.yml"
}

main_fun
#### usage
#./tool/gen-docker-compose.sh
