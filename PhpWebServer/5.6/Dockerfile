FROM docker-0.unsee.tech/ubuntu:22.04

ENV DEBIAN_FRONTEND=noninteractive \
    TZ=Asia/Shanghai \
    LC_ALL=C.UTF-8

RUN apt-get update \
    && apt-get install -y \
    wget curl vim \
    iproute2 net-tools iputils-ping nmap \
    software-properties-common ca-certificates lsb-release \
    libncurses5 libnuma1 libaio1 libmecab2 libncurses5 libaio1 libmecab2 \
    perl-modules-5.34 libdbd-mysql-perl libdbi-perl libdevel-checklib-perl \
    supervisor openssh-server apt-utils apparmor \
    # 安装 PHP 5.6
    && LC_ALL=C.UTF-8 add-apt-repository -y ppa:ondrej/php \
    && apt-get update \
    && apt-get install -y \
    php5.6 \
    php5.6-fpm \
    php5.6-common \
    php5.6-mysql \
    php5.6-gd \
    php5.6-mbstring \
    php5.6-curl \
    php5.6-soap \
    php5.6-json \
    php5.6-xml \
    php5.6-apcu \
    php5.6-mcrypt \
    php5.6-cgi \
    php5.6-dev \
    apache2 \
    libapache2-mod-php5.6

COPY mysql.cnf /tmp
COPY init.sql /tmp

RUN cd /tmp \
    && wget https://cdn.mysql.com/archives/mysql-5.7/mysql-server_5.7.34-1ubuntu18.04_amd64.deb-bundle.tar \
    && tar -xf mysql-server*.tar \
    && rm mysql-server_*.deb-bundle.tar mysql-test*.deb mysql-community-test*.deb \
    && apt-get install -y ./mysql-common*.deb ./mysql-community-client*.deb ./mysql-client*.deb ./mysql-community-server*.deb ./mysql-server*.deb \
    && rm -rf *.deb \
    && install -m 644 /tmp/mysql.cnf /etc/mysql/mysql.conf.d/mysqld.cnf \
    && (mysqld_safe &)\
    && sleep 5 \
    && mysql -uroot -proot -e "SOURCE /tmp/init.sql;" \
    && rm -rf /tmp/init.sql /tmp/mysql.cnf \
    && killall mysqld \
    && chmod -R 777 /usr/lib/mysql/plugin

# 配置 Supervisor
COPY supervisord.conf /etc/supervisor/conf.d/supervisord.conf

# 配置 SSH
RUN echo 'root:p@ss1234' | chpasswd \
    && sed -i 's/#PermitRootLogin prohibit-password/PermitRootLogin yes/' /etc/ssh/sshd_config \
    && sed -i 's/UsePAM yes/UsePAM no/' /etc/ssh/sshd_config \
    && sed -i 's/#PasswordAuthentication yes/PasswordAuthentication yes/' /etc/ssh/sshd_config \
    && ssh-keygen -A \
    && mkdir -p  /var/run/sshd

EXPOSE 80 22 3306

CMD ["/usr/bin/supervisord", "-n"]