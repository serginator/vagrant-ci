#!/bin/bash

if [ ! -f /usr/bin/git ]; 
then
    echo "------------ PROVISIONING GIT ---------------"
    echo "---------------------------------------------"

    ## Install git
    apt-get update
    apt-get -y install git-core curl
else
    echo "CHECK - Git already installed"
fi


if [ ! -f /usr/lib/jvm/java-7-oracle/bin/java ]; 
then
    echo "-------- PROVISIONING JAVA ------------"
    echo "---------------------------------------"

    ## Make java install non-interactive
    ## See http://askubuntu.com/questions/190582/installing-java-automatically-with-silent-option
    echo debconf shared/accepted-oracle-license-v1-1 select true | \
      debconf-set-selections
    echo debconf shared/accepted-oracle-license-v1-1 seen true | \
      debconf-set-selections

    ## Install java 1.7
    ## See http://www.webupd8.org/2012/06/how-to-install-oracle-java-7-in-debian.html
    echo "deb http://ppa.launchpad.net/webupd8team/java/ubuntu trusty main" | tee /etc/apt/sources.list.d/webupd8team-java.list
    echo "deb-src http://ppa.launchpad.net/webupd8team/java/ubuntu trusty main" | tee -a /etc/apt/sources.list.d/webupd8team-java.list
    apt-key adv --keyserver keyserver.ubuntu.com --recv-keys EEA14886
    apt-get update
    apt-get -y install oracle-java7-installer
else
    echo "CHECK - Java already installed"
fi
 
if [ ! -f /etc/init.d/jenkins ]; 
then
    echo "-------- PROVISIONING JENKINS ------------"
    echo "------------------------------------------"


    ## Install Jenkins
    #
    # URL: http://localhost:8080
    # Home: /var/lib/jenkins
    # Start/Stop: /etc/init.d/jenkins
    # Config: /etc/default/jenkins
    # Jenkins log: /var/log/jenkins/jenkins.log
    wget -q -O - http://pkg.jenkins-ci.org/debian/jenkins-ci.org.key | sudo apt-key add -
    sh -c 'echo deb http://pkg.jenkins-ci.org/debian binary/ > /etc/apt/sources.list.d/jenkins.list'
    apt-get update
    apt-get -y install jenkins

    /etc/init.d/jenkins restart
else
    echo "CHECK - Jenkins already installed"
fi

echo "----------- UPDATING DISTR0 --------------"
echo "------------------------------------------"

apt-get install -y build-essential zip unzip nmap 
apt-get dist-upgrade -y

if [ ! -f /usr/local/bin/nvm ];
then
    echo "----------- PROVISIONING NVM -------------"
    echo "------------------------------------------"

    curl https://raw.githubusercontent.com/xtuple/nvm/master/install.sh | bash

    nvm install 0.10
    nvm alias default 0.10

    npm install -g grunt-cli coffee-script yo bower node-inspector jshint
else
    echo "CHECK - NVM already installed"
fi

if [ ! -f /etc/sonarqube ];
then
    echo "-------- PROVISIONING Sonarqube ----------"
    echo "------------------------------------------"
    
    cd /tmp
    wget http://dist.sonar.codehaus.org/sonarqube-5.1.zip
    wget http://repo1.maven.org/maven2/org/codehaus/sonar/runner/sonar-runner-dist/2.4/sonar-runner-dist-2.4.zip

    unzip sonarqube-5.1.zip
    mkdir /etc/sonarqube
    mv sonarqube-5.1/* /etc/sonarqube/
    rm -rf /tmp/sonarqube*

    unzip sonar-runner-dist-2.4.zip
    mkdir /etc/sonar-runner
    mv sonar-runner-2.4/* /etc/sonar-runner/
    rm -rf /tmp/sonar-runner*

    /etc/sonarqube/bin/linux-x86-64/sonar.sh start

else
    echo "CHECK - Sonar already installed"
fi

echo "-------- PROVISIONING DONE ------------"
echo "-- Jenkins: http://localhost:8080      "
echo "-- Sonar: http://localhost:9000        "
echo "---------------------------------------"
