FROM httpd:2.4.35
ADD docker-ce-stable.repo /etc/yum.repos.d/docker-ce-stable.repo
RUN \
  apt-get update &&\
  apt-get -y install yum-utils createrepo curl &&\
  touch /etc/yum.conf &&\
  mkdir -p /var/lib/reposync &&\
  reposync --newest-only -r docker-ce-stable -p /var/lib/reposync &&\
  mkdir -p /usr/local/apache2/htdocs/linux/centos/7/x86_64 &&\
  createrepo /var/lib/reposync/docker-ce-stable &&\
  cd /usr/local/apache2/htdocs/linux/centos &&\
  curl -O -L https://download.docker.com/linux/centos/gpg &&\
  ln -s /var/lib/reposync/docker-ce-stable /usr/local/apache2/htdocs/linux/centos/7/x86_64/stable &&\
  rm /usr/local/apache2/htdocs/index.html &&\
  rm /etc/yum.conf &&\
  apt-get -y remove yum-utils createrepo curl &&\
  apt-get -y autoremove &&\
  rm -rf /var/lib/apt/lists/*
