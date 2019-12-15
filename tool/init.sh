#!/bin/sh

THIS_FILE_PATH=$(
    cd $(dirname $0)
    pwd
)

THIS_PROJECT_PATH=$(path_resolve "$THIS_FILE_PATH" "../")
# the dir runing the shell init.sh
RUN_SCRIPT_PATH=$(pwd)

source "$THIS_FILE_PATH/prepare-be-jsp.sh"
source "$THIS_FILE_PATH/prepare-fe.sh"

# run the docker-compose
cd ${RUN_SCRIPT_PATH}
docker-compose up -d
