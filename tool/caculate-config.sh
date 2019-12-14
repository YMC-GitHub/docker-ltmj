#!/bin/sh

THIS_FILE_PATH=$(
    cd $(dirname $0)
    pwd
)
source $THIS_FILE_PATH/function-list.sh
THIS_PROJECT_PATH=$(path_resolve "$THIS_FILE_PATH" "../")
RUN_SCRIPT_PATH=$(pwd)

declare -A dic
dic=()

function main_fun() {
    local KEY_VAL_MAP=
    local key=
    local val=
    local i=
    local KEY_VAL_ARR=
    local REG_SHELL_COMMOMENT_PATTERN=
    local path=
    KEY_VAL_MAP=$(
        cat <<EOF
#save conf for static web serve nginx in PM
  PM.dir.nginx=nginx
#save conf for dymatic web serve php in PM
  PM.dir.php-fpm=php-fpm
#save conf,data for db serve in mysql PM
  PM.dir.mysql=mysql
#save web,scripts for web serve xx in PM
  PM.dir.app=app
#the name of container name for static web serve nginx
  CM.nginx=nginx
#the name of container name for dymatic web serve php
  CM.php-fpm=php-fpm
#the name of container name for db serve mysql
  CM.mysql=mysql
#the name of container name for web serve xx
#  CM.app=app
#set the image for static web serve nginx
  image.nginx=nginx:latest
#set the image for dymatic web serve php
#image.php-fpm=php-fpm
#set the image for db serve mysql
  image.mysql=mysql:latest
#set the image for web serve xx
#image.app=app
#set the image for static web serve nginx
#  build.nginx=nginx
#set the image for dymatic web serve php
  build.php-fpm=./php-fpm
#set the image for db serve mysql
#  build.mysql=mysql
#set the image for web serve xx
#  build.app=app
#set the port for static web serve nginx
#  port.nginx="443:443 80:80"
#set the port for dymatic web serve php
  port.php-fpm="9000"
#set the port for db serve mysql
  port.mysql="3306:3306"
#set the port for web serve xx
  port.app=app
#set the volume for static web serve nginx
#  volume.nginx="./app/src:/usr/share/nginx/html ./nginx/nginx.conf:/etc/nginx/nginx.conf:ro ./nginx/conf.d/:/etc/nginx/conf.d/:ro ./nginx/ca/server.crt/:/etc/nginx/server.crt:ro ./nginx/ca/server.key/:/etc/nginx/server.key:ro"
#set the volume for dymatic web serve php
#  volume.php-fpm="./app/src:/usr/share/nginx/html ./php-fpm/php.ini-production:/usr/local/etc/php/php.ini:ro"
#set the volume for db serve mysql
  volume.mysql=./mysql:/var/lib/mysql
#set the volume for web serve xx
#  volume.app=app
#set the link for static web serve nginx
  link.nginx=php-fpm:__DOCKER_PHP_FPM__
#set the link for dymatic web serve php
  link.php-fpm=mysql:mysql
#set the link for db serve mysql
#  link.mysql=
#set the link for web serve xx
#  link.app=app
#set the env var for static web serve nginx in CM
#  env.nginx=nginx
#set the env var for dymatic web serve php in CM
#  env.php-fpm=$CM_PHP_FPM_ENV
#set the env var for db serve mysql in CM
  env.mysql=MYSQL_ROOT_PASSWORD=your_mysql_password
#set the env var for web serve xx in CM
#  env.app=app
EOF
    )
    if [ -n "${1}" ]; then
        KEY_VAL_MAP="${1}"
    fi
    KEY_VAL_MAP=$(echo "$KEY_VAL_MAP" | sed "s/^ *#.*//g" | sed "/^ *$/d")
    REG_SHELL_COMMOMENT_PATTERN="^#"
    KEY_VAL_ARR=(${KEY_VAL_MAP//,/ })
    for i in "${KEY_VAL_ARR[@]}"; do
        # 获取键名
        key=$(echo $i | awk -F'=' '{print $1}')
        # 获取键值
        val=$(echo $i | awk -F'=' '{print $2}')
        dic+=([$key]=$val)
    done
    # for val with multi-line
    CM_PHP_FPM_ENV=$(
        cat <<EOF
- APP_KEY=
- DB_HOST=
- DB_DATABASE=
- DB_USERNAME=
- DB_PASSWORD=
EOF
    )
    dic+=(["env.php-fpm"]=$CM_PHP_FPM_ENV)
    CM_NGINX_PORT=$(
        cat <<EOF
- "443:443"
- "80:80"
EOF
    )
    dic+=(["env.nginx"]=$CM_NGINX_PORT)
    CM_NGINX_VOLUME=$(
        cat <<EOF
- ./app/src:/usr/share/nginx/html
- ./nginx/nginx.conf:/etc/nginx/nginx.conf:ro 
- ./nginx/conf.d/:/etc/nginx/conf.d/:ro 
- ./nginx/ca/server.crt/:/etc/nginx/server.crt:ro 
- ./nginx/ca/server.key/:/etc/nginx/server.key:ro
EOF
    )
    dic+=(["volume.nginx"]=$CM_NGINX_VOLUME)
    CM_PHP_FPM_VOLUME=$(
        cat <<EOF
- ./app/src:/usr/share/nginx/html 
- ./php-fpm/php.ini-production:/usr/local/etc/php/php.ini:ro
EOF
    )
    dic+=(["volume.php-fpm"]=$CM_PHP_FPM_VOLUME)
}
function output_config() {
    local key=
    local val=
    local TXT=
    for key in "${!dic[@]}"; do
        val=${dic[$key]}
        TXT=$(
            cat <<EOF
$TXT
#$key
$val
EOF
        )
    done
    TXT=$(echo "$TXT" | sed "/^ *$/d")
    echo "$TXT"
}
main_fun
#echo "ouput config key val"
#output_config
#### usage
#./tool/caculate-config.sh
