FROM jenkins/jenkins:2.321
# if we want to install via apt
USER root

RUN apt-get update \
      && apt-get --allow-unauthenticated install -y sudo \
      && rm -rf /var/lib/apt/lists/*
RUN echo "jenkins ALL=NOPASSWD: ALL" >> /etc/sudoers
RUN apt-get update -y && apt-get install -y python3-dev

# Docker
RUN curl -fsSLO https://get.docker.com/builds/Linux/x86_64/docker-17.04.0-ce.tgz \
  && tar xzvf docker-17.04.0-ce.tgz \
  && mv docker/docker /usr/local/bin \
  && rm -r docker docker-17.04.0-ce.tgz

RUN apt-get update -yqq \
    && apt-get upgrade -yqq

# kubectl installation
RUN apt-get update \
      && apt-get install -y apt-transport-https \
      && curl -s https://packages.cloud.google.com/apt/doc/apt-key.gpg | apt-key add -
RUN echo "deb https://apt.kubernetes.io/ kubernetes-xenial main" | sudo tee -a /etc/apt/sources.list.d/kubernetes.list
RUN apt-get update \
      && apt-get install -y kubectl
RUN apt-get update && apt-get install git-crypt
RUN apt-get update && apt-get install -y jq

#RUN apt-get update && apt-get install -y awscli
#setup tools installation (for CI to push python wheel/egs to pfizer repos)
RUN apt-get update \
      && apt-get install -y python-setuptools
      
#COPY .pypirc /var/jenkins_home/



USER jenkins
