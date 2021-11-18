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

ENV DEBIAN_FRONTEND=noninteractive
ENV PYTHON_VERSION="3.7.3"

# Install core packages
RUN apt-get update
RUN apt-get install -y build-essential checkinstall software-properties-common llvm cmake wget git nano nasm yasm zip unzip pkg-config \
    libreadline-gplv2-dev libncursesw5-dev libssl-dev libsqlite3-dev tk-dev libgdbm-dev libc6-dev libbz2-dev mysql-client default-libmysqlclient-dev
#RUN apt-get install python3-dev

# Install Python 3.7.3
RUN wget https://www.python.org/ftp/python/${PYTHON_VERSION}/Python-${PYTHON_VERSION}.tar.xz \
    && tar xvf Python-${PYTHON_VERSION}.tar.xz \
    && rm Python-${PYTHON_VERSION}.tar.xz \
    && cd Python-${PYTHON_VERSION} \
    && ./configure \
    && make altinstall \
    && cd / \
    && rm -rf Python-${PYTHON_VERSION} \
    && if [ -e /usr/bin/python3.7 ]; then rm -f /usr/bin/python3.7; fi \
    && ln -s /usr/local/bin/python3.7 /usr/bin/python3.7 \
    && if [ -e /usr/bin/pip3.7 ]; then rm -f /usr/bin/pip3.7; fi \
    && ln -s /usr/local/bin/pip3.7 /usr/bin/pip3.7 \
    && pip3.7 install --upgrade pip

RUN pip install yq
RUN curl "https://awscli.amazonaws.com/awscli-exe-linux-x86_64.zip" -o "awscliv2.zip"
RUN unzip awscliv2.zip
RUN ./aws/install

RUN pip install anchorecli

RUN pip install pytest

RUN curl -sL https://deb.nodesource.com/setup_17.x | sudo bash -
RUN apt-get install -y nodejs
RUN apt-get install -y npm
RUN npm install -g newman

USER jenkins
