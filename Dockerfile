# Dockerfile to build caravel container images
# based on centos

FROM centos:7.2.1511
#FROM centos:7
MAINTAINER xingzhi

# install base
RUN yum -y update
RUN yum -y groupinstall "Development tools"

# install pip
RUN yum install -y epel-release
RUN yum install -y python-pip
RUN pip install --upgrade pip

# install dependies
RUN yum install -y libffi-devel
RUN yum install -y libgsasl-devel
RUN yum install -y libmemcached-devel
RUN yum install -y numpy
RUN yum install -y python-devel
RUN yum install -y openssl
RUN yum install -y openssl-devel
RUN pip install --upgrade pytz

# install nodejs
WORKDIR /usr/local/
ADD http://nodejs.org/dist/v4.5.0/node-v4.5.0.tar.gz /usr/local/
RUN tar -zxvf node-v4.5.0.tar.gz
WORKDIR /usr/local/node-v4.5.0/
RUN ./configure --prefix=/usr/local/
RUN make
RUN make install
RUN ln -s /usr/local/bin/node /usr/bin/node
#RUN echo "export PATH=/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin" >> /etc/profile
#RUN source /etc/profile

# install npm
#ADD https://npmjs.org/install.sh /usr/local/node-v4.5.0/
#RUN sh install.sh
#RUN curl -L https://npmjs.org/install.sh | sh

# install express
#RUN npm install express -g

# install caravel
WORKDIR /usr/local/
ADD https://github.com/airbnb/caravel/archive/master.zip /usr/local/
RUN unzip master.zip
WORKDIR /usr/local/caravel-master/caravel/assets/
RUN npm install
RUN npm run prod
WORKDIR /usr/local/caravel-master/
RUN python setup.py install

# run
#RUN caravel db upgrade
#RUN caravel init
#RUN caravel load_examples

# Deploy 
#EXPOSE 8088 
#ENTRYPOINT ["caravel"] 
#CMD ["runserver"]
