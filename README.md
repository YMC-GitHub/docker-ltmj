## background

to standard and simple building and running java web in dev/pro env.
## dependences

some important soflt need to be prepared:

- [Git](https://git-scm.com/downloads)
- [Docker](https://www.docker.com/products/docker/)
- [Docker-Compose](https://docs.docker.com/compose/install/#install-compose)
## database for mysql

- `hostname: mysql`

the state will add a host resovle in the db cm `mysql`, in file  `/etc/hosts` with content `xxx.xx.xx.xx mysql`.
it will map the address `http://mysql`  to the db cm  `mysql`,equals to `http://localhost` in  the db cm  `mysql`
## data for persistence

the data in cm will destory when the cm is destory, you need to make volume maping from cm path to your pm path in  `docker-compose.yml`:

- `/var/lib/mysql` the db cm `mysql` data file path must to mount to your  pm path
- `/usr/local/tomcat/logs` the serve cm tomcat log file path .you can mount to  your pm path too
- `/data` the db cm `redis` data file path
- `/data/activemq` the db cm `activemq` data file path will map the address `http://mysql`  to the db cm  `mysql`,equals to `http://localhost` in  the db cm  `mysql`

## project simple usage 

after debuging the project,start with  `-d` arg to run in backgroud process.
you also can use  `docker-compose logs -f` to get start log.

```sh
# run in backgroud process
docker-compose up -d

# get the start log
docker-compose logs -f
```

## some important solft for java web

- **JAVA** ：`1.8`
- **Tomcat** ：`8.5.41`
- **maven** ：`maven:3.6.1-jdk-8` 
- **MySQL** ：`10.3.15`
- **Redis** ：`5.0.7`
- **ActiveMQ** ：`5.14.3`


the maven you can update it in init-conf.sh file.
the other solft version updated in `docker-compose.yml` file or `Dockerfile` file

```yml
# fetch from a remote image
# image: redis:5.0.7
# build image with a local config
  build: ./redis
```

after updating `docker-compose.yml` file or `Dockerfile` file,need to  rebuild image .you can run as below but not last:
```sh
docker-compose up --build
```

## the project dir construtor

```
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
```
