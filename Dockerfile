#############################################################################
# Dockerizing tierce platform: Dockerfile for building tierce platform images
# Based on fedora:latest
#############################################################################
FROM fedora:latest

MAINTAINER Samuel Dewaele <samuel.dewaele@iteolia.com>

# TODO: check root password and add a user

#RUN yum update -y -t

# install basic tools
RUN yum install -y wget unzip expect pwgen

# install java
RUN mkdir -p /opt/oracle 
RUN wget -q --no-cookies --no-check-certificate --header "Cookie: gpw_e24=http%3A%2F%2Fwww.oracle.com%2Ftechnetwork%2Fjava%2Fjavase%2Fdownloads%2Fjdk7-downloads-1880260.html; oraclelicense=accept-securebackup-cookie" http://download.oracle.com/otn-pub/java/jdk/7u67-b01/jdk-7u67-linux-x64.tar.gz
RUN mv -v  jdk-7u67-linux-x64.tar.gz /opt/oracle
RUN cd /opt/oracle && tar zxf jdk-7u67-linux-x64.tar.gz
RUN cd /opt/oracle/ && rm -vf jdk-7u67-linux-x64.tar.gz
RUN ln -svn /opt/oracle/jdk1.7.0_67 /opt/oracle/jdk

RUN echo "JAVA_HOME=/opt/oracle/jdk" >> /etc/environment
ENV JAVA_HOME /opt/oracle/jdk
ENV PATH $JAVA_HOME/bin:$PATH

# installs glassfish
RUN wget -q  --no-cookies --no-check http://download.java.net/glassfish/4.0/release/glassfish-4.0.zip

RUN mv -v glassfish-4.0.zip /opt/oracle/
RUN cd /opt/oracle && unzip -q glassfish-4.0.zip
RUN ln -svn /opt/oracle/glassfish4 /opt/oracle/glassfish

RUN echo "GLASSFISH_HOME=/opt/oracle/glassfish"
ENV GLASSFISH_HOME /opt/oracle/glassfish

ENV PATH $GLASSFISH_HOME/bin:$PATH

#ADD run.sh /run.sh
#RUN chmod +x run.sh

# 4848 (administration), 8080 (HTTP listener), 8181 (HTTPS listener)
EXPOSE 4848 8080 8181

# MongoDB following the instructions from:
# http://docs.mongodb.org/manual/tutorial/install-mongodb-on-ubuntu/

RUN echo -e '[mongodb]\nname=MongoDB Repository\nbaseurl=http://downloads-distro.mongodb.org/repo/redhat/os/x86_64/\ngpgcheck=0\nenabled=1'|tee /etc/yum.repos.d/mongodb.repo  
RUN yum install -y mongodb-org
RUN  mkdir -p /data/db
RUN service mongod start

# Define mountable directories.
#VOLUME ["/data"]

# Define working directory.
#WORKDIR /data

# Define default command.
#CMD ["mongod"]