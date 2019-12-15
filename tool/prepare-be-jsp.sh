#!/bin/sh

#################################################
# automaticly
# pull maven lib ,docker  image
# pack war file
# move war file to pm dir where you will mount to cm
#################################################

# use anthor way to pack:
# split maven and tomcat images
# use an alone cm to pull maven lib , docker image and pack docker file ,then mv to pm mount dir

THIS_FILE_PATH=$(
    cd $(dirname $0)
    pwd
)
source "$THIS_FILE_PATH/function-list.sh"
source "$THIS_FILE_PATH/config.sh"
THIS_PROJECT_PATH=$(path_resolve "$THIS_FILE_PATH" "../")
# the dir runing the shell init.sh
RUN_SCRIPT_PATH=$(pwd)
# include the conf in prepare-be-jsp-conf.sh
source "$THIS_FILE_PATH/prepare-be-jsp-conf.sh"

# the cm name for tool
CM_MAVEN_NAME=mvn_building_xx
# clear source dir
rm -fr ${WORK_DIR}/${SRC_DIR}
# create working dor
mkdir -p ${WORK_DIR} && cd ${WORK_DIR}
# pull source dir from remote with git tool
git clone -b ${BRANCH} "http://"${GIT_USERNAME}":"${GIT_PASSWORD}"@"${URL}

# make a dir to save maven libs
# or create a named volume
M2_TYPE=$(echo "$M2_TYPE" | tr '[A-Z]' '[a-z]')
if [ $M2_TYPE = "DIR" ]; then
    mkdir -p ${M2_VOLUME_NAME}
else
    docker volume ls grep "${M2_VOLUME_NAME}"
    if [[ $? -ne 0 ]]; then
        #docker volume rm --force "${M2_VOLUME_NAME}"
        #else
        docker volume create --name "${M2_VOLUME_NAME}"
    fi
fi

# check wethear the cm exsits or not
# if the cm exsits, delete
# create,start the cm to gen gen war then delete the cm
PWD_DIR="$RUN_SCRIPT_PATH"
docker ps -a | grep ${CM_MAVEN_NAME}
if [[ $? -eq 0 ]]; then
    docker rm ${CM_MAVEN_NAME}
    #docker start ${CM_MAVEN_NAME}
    #docker logs -f ${CM_MAVEN_NAME}
else
    # uses maven to gen war file in docker
    docker run \
        -it \
        --rm \
        --name ${CM_MAVEN_NAME} \
        -v ${PWD_DIR}/maven/conf:/usr/share/maven/ref \
        -v ${WORK_DIR}/${SRC_DIR}:/usr/src/mymaven \
        -v ${M2_VOLUME_NAME}:/root/.m2 \
        -w /usr/src/mymaven \
        "${IMG_MAVEN}" \
        "${CM_MAVEN_CMD}"
fi

# mv the war file to pm mount dir for tomcat
mkdir --parents ${PWD_DIR}/${TOMCAT_DIR}
cp --force --recursive ${WORK_DIR}/${SRC_DIR}/target/* ${PWD_DIR}/${TOMCAT_DIR}
