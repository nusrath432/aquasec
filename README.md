# Aquasec Assignment
>DISCLAIMER: The information contained in this repository is for testing purposes only. In no event will the author be liable for any loss or damage including without limitation, indirect or consequential loss or damage, or any loss or damage whatsoever arising from loss of data or profits arising out of, or in connection with, the use of this code.

### Bootstrapping 
>CAUTION: The bootstrap.sh script will install/remove docker and its containers on any linux node (tested on Ubuntu 18.04). DO NOT execute it on production or any important node.

To bootstrap any node excute the following command:
```sh
$ sudo chmod ug+x ./bootstrap.sh
$ sudo ./bootstrap
```

### Task Execution
1. Created a vanilla KVM instance "jenkins-master"
2. Configured Git and cloned the following https://github.com/nusrath432/aquasec.git repo which has:
	a. bootstrap.sh script - installs docker, jenkins master in a docker container on any linux node [tested only on Ubuntu 18.04]
	b. Dockerfile - Has defination of the image to be build and pushed to hub.docker.io
	c. Readme.md - Instructions file
3. Executed bootstrap.sh to install Jenkins Docker container
4. Launched Jenkins GUI and created build-docker-images-freestyle & build-docker-images-pipeline with build trigger (GitHub hook trigger for GITScm polling)
   Note: Since the KVM is running on my work laptop, the webhook on my git repository [http://91.189.88.154:8080/github-webhook/  (push)] is not accessible. Hence, I had to run the build manually.
5. On build execution, the git repository nusrath432/aquasec from github gets cloned to /var/jenkins_home/workspace/build-docker-images-freestyle within jenkin container and then pushed to the hub.docker.io registry with tag as nusrath432/aquasec:<$GIT_COMMIT>


### Git Hub
https://github.com/nusrath432/aquasec.git

### Jenkins KVM
```
nusrath@jenkin-master:~/aquasec$ docker ps -a
CONTAINER ID        IMAGE                 COMMAND                  CREATED             STATUS              PORTS                                              NAMES
1bc20cbc2a51        jenkins/jenkins:lts   "/sbin/tini -- /usr/…"   4 hours ago         Up 4 hours          0.0.0.0:8080->8080/tcp, 0.0.0.0:50000->50000/tcp   jenkin-master

nusrath@jenkin-master:~/aquasec$ docker images
REPOSITORY           TAG                                        IMAGE ID            CREATED             SIZE
nusrath432/aquasec   53e8997055750e82322d06b53ca08de17e348d86   0586934d4ae0        11 hours ago        173MB
nusrath432/aquasec   latest                                     0586934d4ae0        11 hours ago        173MB
nusrath432/nginx     latest                                     0586934d4ae0        11 hours ago        173MB

nusrath432/aquasec   83e1291432d282177c3efa1fc09dcae028046db1   20cf35a3efbc        11 hours ago        199MB
nusrath432/aquasec   33cfc57b96a039c871b8bb5feeacd1702f8fc9fa   07c8c04ba3d9        11 hours ago        222MB

jenkins/jenkins      lts                                        256cb12e72d6        2 weeks ago         702MB

ubuntu               16.04                                      9361ce633ff1        2 weeks ago         118MB
ubuntu               14.04                                      390582d83ead        2 weeks ago         188MB
ubuntu               18.04                                      94e814e2efa8        2 weeks ago         88.9MB

```

### Jenkins Console Output
>build-docker-images-freestyle

Ubuntu:14.4 - https://pastebin.com/M29zEq2j

Ubuntu:16.4 - https://pastebin.com/4CiysGC1

Ubuntu:18.4 - https://pastebin.com/FQpxD53V

>build-docker-images-pipeline

https://pastebin.com/a6KdrAb0

### Docker Hub
https://cloud.docker.com/repository/registry-1.docker.io/nusrath432/aquasec/tags


### Challenges Faced
1. In general, setting up this workflow took some time as I have not used Docker or Jenkins before.
2. Bootstraping and running docker commands as non-sudo user without logging-out of the current session.
3. Mounting the  -v /var/run/docker.sock:/var/run/docker.sock and using the unix:///var/run/docker.sock for authentication - didn't work until I restarted the jenkin-master container.
4. Took some significant time to figure out how to run docker within docker container - used -v $(which docker):/usr/bin/docker
5. Getting the hub.docker.io authenticated via Jenkin GUI was difficult even when using the right credentials - had to use the Docker registry URL: https://index.docker.io/v1/ to get it working.