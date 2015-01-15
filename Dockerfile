FROM ubuntu:14.04
 
ENV DEBIAN_FRONTEND noninteractive
RUN apt-get update
RUN locale-gen en_US en_US.UTF-8
ENV LANG en_US.UTF-8

#Runit
RUN apt-get install -y runit 
CMD /usr/sbin/runsvdir-start

#Utilities
RUN apt-get install -y vim less net-tools inetutils-ping wget curl git telnet nmap socat dnsutils netcat tree htop unzip sudo software-properties-common

#Node
RUN curl http://nodejs.org/dist/v0.10.35/node-v0.10.35-linux-x64.tar.gz | tar xz
RUN mv node* node && \
    ln -s /node/bin/node /usr/local/bin/node && \
    ln -s /node/bin/npm /usr/local/bin/npm
ENV NODE_PATH /usr/local/lib/node_modules
RUN npm -g install bower
RUN npm install -g grunt-cli bower

RUN git clone --depth 1 https://github.com/swagger-api/swagger-editor.git
#Workaround this issue, https://github.com/swagger-api/swagger-editor/issues/296
RUN cd /swagger-editor && \
    sed -i "s|~0.7.6|0.7.6|" bower.json && \
    sed -i "s|~1.1.0|1.0.4|" bower.json 
RUN cd /swagger-editor && \
    npm install && \
    bower install --allow-root && \
    grunt build

#Add runit services
ADD sv /etc/service 
