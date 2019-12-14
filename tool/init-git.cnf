# after updating this file
# run the start shell  init.sh

#the source repo,not adding http
URL=xx.git

# the git user name
GIT_USERNAME=xxx

# the git user pass
GIT_PASSWORD=xxx

# the branch to release
BRANCH=release

# the maven env and some arg
the maven image
IMG_MAVEN="maven:3.6.1-jdk-8-alpine"
#IMG_MAVEN="maven:3.6.0-jdk-8"
#https://hub.docker.com/_/maven?tab=tags&page=1&name=alpine

# the cmd cm maven ruun 
CM_MAVEN_CMD="mvn clean package -U -DskipTests -P pro"
# the maven solft working dir in you pm path
WORK_DIR=/mvn/build

#the libs path maven installed in your pm path. saving it in your pm path,no download again and again
M2_TYPE="DIR" #NAME
#use your home .m2 cache directory that you share e.g. with your Eclipse/IDEA
M2_DIR=/mvn/m2-volume
M2_VOLUME_NAME="$M2_DIR"
#OR usr a volume 
#LOCAL_MAVEN_REPO=maven-repo
#M2_VOLUME_NAME="$LOCAL_MAVEN_REPO"

# set the source download dir in your pm path
# accoding to git url
SRC_DIR=`echo ${URL} | awk -F'/' '{print $3}' | cut -f1 -d "."`

# move the war package packed to the pm path 
# where you will mount to cm path tomcat/webapps
# default dir is in the project tomcat/webapps
TOMCAT_DIR=tomcat/webapps
