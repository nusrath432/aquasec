#!/bin/bash
set +ex

if [[ -z $(command -v docker) ]]; then
        echo "Installing Docker ..."

        # Removing legacy Docker software:
        echo "Removing legacy Docker software"
	sudo apt -y  --allow-change-held-packages purge --remove docker docker-ce docker-engine docker.io containerd runc containerd.io docker-ce-cli && sudo apt -y autoremove

        # Installing latest Docker Engine (Stable Community Version):
        ## Allow apt to use a repository over HTTPS:
        sudo apt install -y apt-transport-https ca-certificates curl gnupg-agent software-properties-common

        ## Add Docker's Official GPG key:
        curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo apt-key add -

        ## Add Docker's stable repository to apt index:
        sudo add-apt-repository "deb [arch=amd64] https://download.docker.com/linux/ubuntu $(lsb_release -cs) stable"

        ## Install Docker Engine & apt-mark hold to restrict auto-upgrade
        echo "Installing Docker Engine (community version - latest stable) from docker.io"
        sudo apt update && sudo apt -y install docker-ce docker-ce-cli containerd.io && sudo apt-mark hold docker-ce docker-ce-cli containerd.io
	sudo systemctl status docker 
        sudo usermod -aG docker "$(whoami)";

        echo "Docker Installation complete."
else
        echo "Docker already installed ... "
fi

sudo docker version
echo ""

# Check if Docker engine is running or not
if [[ -z $(pgrep docker) ]]; then
       	echo "Docker Service is not running"; sudo systemctl start docker; sleep 5; sudo docker version 
fi

# Check for Jenkins Docker Container 
if [[ -z "$(sudo docker ps -q -f name=jenkin-master)" ]]; then
	echo -e "There is no jenkin-master running ...\n"
	if [[ -z "$(sudo docker ps -aq -f name=jenkin-master)" ]]; then
		echo "jenkin-master container does not exist at all ... creating NEW container"
		# Launch Jenkins container (latest lts) from jenkins.io
        	sudo docker run -d -p 8080:8080 -p 50000:50000 -v /home/"$(whoami)"/jenkins-master:/var/jenkins_home --name jenkin-master jenkins/jenkins:lts
		sleep 5
	else
		echo "Starting existing Jenkin-master container"
		sudo docker start jenkin-master
	fi
else
	echo -e "Jenkins container already running: \n"
	echo -e "$(sudo docker ps -f name=jenkin-master) \n" 
fi 

sleep 10

echo -e "Please use the following password to log into Jenkins UI: $(sudo docker exec -u root jenkin-master cat /var/jenkins_home/secrets/initialAdminPassword) \n"

## END
