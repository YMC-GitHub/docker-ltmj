#!/bin/sh

THIS_FILE_PATH=$(
    cd $(dirname $0)
    pwd
)
source $THIS_FILE_PATH/function-list.sh
source $THIS_FILE_PATH/config.sh
THIS_PROJECT_PATH=$(path_resolve "$THIS_FILE_PATH" "../")
RUN_SCRIPT_PATH=$(pwd)

function add_background() {
    local TXT=
    TXT=$(
        cat <<EOF
## background

to standard and simple building and running java web in dev/pro env.
EOF
    )
    echo "$TXT"
}
function add_start() {
    local TXT=
    TXT=$(
        cat <<EOF
## quick to start

you can do it as below but not last:
\`\`\`sh
#clone the project
git clone https://github.com/ymc-github/javaweb-compose.git
#go to the project dir
cd javaweb-compose
#update  git conf for your user,pass
#vi init-conf.sh 
#
sh init.sh
\`\`\`s

some cmd to opsdev :

\`\`\`sh
# get docker-compose help
docker-compose help
#create and start docker serve with docker-compose
docker-compose up
#stop and remove docker serve with docker-compose after update docker-compose file or dockerfile
docker-compose down
# go to cm
docker-compose exec javaweb-compose bash
\`\`\`

EOF
    )
    echo "$TXT"
}

function add_deps() {
    local TXT=
    TXT=$(
        cat <<EOF
## dependences

some important soflt need to be prepared:

- [Git](https://git-scm.com/downloads)
- [Docker](https://www.docker.com/products/docker/)
- [Docker-Compose](https://docs.docker.com/compose/install/#install-compose)
EOF
    )
    echo "$TXT"
}
function add_db_for_mysql() {
    local TXT=
    TXT=$(
        cat <<EOF
## database for mysql

- \`hostname: mysql\`

the state will add a host resovle in the db cm \`mysql\`, in file  \`/etc/hosts\` with content \`xxx.xx.xx.xx mysql\`.
it will map the address \`http://mysql\`  to the db cm  \`mysql\`,equals to \`http://localhost\` in  the db cm  \`mysql\`
EOF
    )
    echo "$TXT"
}

function add_data_for_persistence() {
    local TXT=
    TXT=$(
        cat <<EOF
## data for persistence

the data in cm will destory when the cm is destory, you need to make volume maping from cm path to your pm path in  \`docker-compose.yml\`:

- \`/var/lib/mysql\` the db cm \`mysql\` data file path must to mount to your  pm path
- \`/usr/local/tomcat/logs\` the serve cm tomcat log file path .you can mount to  your pm path too
- \`/data\` the db cm \`redis\` data file path
- \`/data/activemq\` the db cm \`activemq\` data file path will map the address \`http://mysql\`  to the db cm  \`mysql\`,equals to \`http://localhost\` in  the db cm  \`mysql\`
EOF
    )
    echo "$TXT"
}

function add_other() {
    local TXT=
    TXT=$(
        cat <<EOF

## project simple usage 

after debuging the project,start with  \`-d\` arg to run in backgroud process.
you also can use  \`docker-compose logs -f\` to get start log.

\`\`\`sh
# run in backgroud process
docker-compose up -d

# get the start log
docker-compose logs -f
\`\`\`

## some important solft for java web

- **JAVA** ：\`1.8\`
- **Tomcat** ：\`$TOMCAT_VERSION\`
- **maven** ：\`maven:$MAVEN_VERSION-jdk-8\` 
- **MySQL** ：\`$MYSQL_VERSION\`
- **Redis** ：\`$REDIS_VERSION\`
- **ActiveMQ** ：\`$ACTIVEMQ_VERSION\`


the maven you can update it in init-conf.sh file.
the other solft version updated in \`docker-compose.yml\` file or \`Dockerfile\` file

\`\`\`yml
# fetch from a remote image
# image: redis:$REDIS_VERSION
# build image with a local config
  build: ./redis
\`\`\`

after updating \`docker-compose.yml\` file or \`Dockerfile\` file,need to  rebuild image .you can run as below but not last:
\`\`\`sh
docker-compose up --build
\`\`\`

## the project dir construtor

\`\`\`
javaweb-compose/
├── activemq
│   ├── data  # pm data path mount to cm
│   ├── Dockerfile   # the image conf file
│   └── logs   # pm log path mount to cm
├── docker-compose.yml  # docker-compose  conf file
├── mysql
│   ├── conf  # pm conf path mount to cm
│   ├── data  # pm data path mount to cm
│   └── Dockerfile   # the image conf file
├── README.md
├── redis
│   ├── conf   # pm conf path mount to cm
│   ├── data  # pm data path mount to cm
│   └── Dockerfile
└── tomcat
    ├── conf    # pm conf path mount to cm
    ├── Dockerfile   # image conf file
    ├── logs   # pm log path mount to cm
    └── webapps
        └── ROOT   # tomcat default project ROOT dir
……………
\`\`\`

EOF
    )
    echo "$TXT"
}

function main_fun() {
    local path=
    local TXT=

    local name="Ye Miancheng"
    local email="ymc.github@gmail.com"
    local homepage="https://github.com/YMC-GitHub"
    local TXT=
    local background_txt=$(add_background)
    local deps_txt=$(add_deps)
    local db_for_mysql_txt=$(add_db_for_mysql)
    local data_for_persistence_txt=$(add_data_for_persistence)
    local another_txt=$(add_other)
    TXT=$(
        cat <<EOF
$background_txt
$deps_txt
$db_for_mysql_txt
$data_for_persistence_txt
$another_txt
EOF
    )

    path="$THIS_PROJECT_PATH/README.md"
    echo "gen readme.md :$path"
    #echo "$TXT"
    echo "$TXT" >"$path"
}
main_fun

#### usage
#./tool/gen-readme.sh
