FROM centos:centos6

USER root

WORKDIR /

#安装yum源   mysql nginx php
ADD ./tools/yum.repos.d/* /etc/yum.repos.d/
ADD ./tools/rpm-gpg/* /etc/pki/rpm-gpg/
RUN rpm -Uvh http://nginx.org/packages/centos/6/noarch/RPMS/nginx-release-centos-6-0.el6.ngx.noarch.rpm
RUN rpm -ivh http://mirrors.aliyun.com/epel/epel-release-latest-6.noarch.rpm


## 创建开发用户
RUN useradd dev -u 1000
RUN echo "plk789" | passwd --stdin "dev"

#安装nginx php mysql redis memcache
RUN yum install nginx redis memcached -y 
ADD ./etc/nginx/nginx.conf /etc/nginx/nginx.conf

RUN yum install -y php php-cli php-mysql php-mbstring php-fpm php-mssql php-xml php-tidy php-pdo php-redis php-pecl-memcache pecl_http
ADD ./etc/php-fpm.conf /etc/php-fpm.conf
ADD ./etc/php-fpm.d/www.conf /etc/php-fpm.d/www.conf
ADD ./etc/php.ini /etc/php.ini

RUN yum install mysql mysql-server -y
RUN mkdir -m 770 /var/log/mysql && chown mysql:mysql /var/log/mysql
RUN mysql_install_db
ADD ./etc/my.cnf /etc/my.cnf

#安装ssh
RUN yum install openssh-server -y

### etc
## set timezone
RUN cp -f /usr/share/zoneinfo/Asia/Shanghai /etc/localtime
RUN echo "plk789" | passwd --stdin "root"

### volumes

## nginx virtual hosts
VOLUME ["/etc/nginx/hosts/"]

## php-fpm
VOLUME ["/etc/php-fpm.d/"]

## web sites
VOLUME ["/home/dev/www/"]

## web logs
VOLUME ["/home/dev/logs/"]

## ssh pub key
VOLUME ["/home/dev/.ssh"]


### main
ADD ./start.sh /start.sh
RUN chmod 755 /start.sh

CMD ["/bin/bash", "/start.sh"]

## allow ports 
EXPOSE 3306
EXPOSE 80
EXPOSE 22
EXPOSE 6379
EXPOSE 11211
EXPOSE 8989