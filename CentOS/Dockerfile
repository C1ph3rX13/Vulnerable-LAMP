FROM hub.mirrorify.net/centos:centos8.4.2105

ENV DEBIAN_FRONTEND=noninteractive

RUN set -ex \
    && sed -i 's/mirrorlist/#mirrorlist/g' /etc/yum.repos.d/CentOS-*.repo \
    && sed -i 's|#baseurl=http://mirror.centos.org|baseurl=http://vault.centos.org|g' /etc/yum.repos.d/CentOS-*.repo \
    && yum clean all \
    && yum makecache \
    && yum -y install dnf dnf-plugins-core \
    && dnf install -y epel-release \
    && dnf clean all && dnf makecache \
    && dnf install -y \
    # Insall basic tools
    vim wget curl sudo \
    openssh-server supervisor\
    mariadb-server mariadb \
    # Install PHP 7.2
    && dnf install -y \
    php php-cli php-fpm php-common php-devel \
    php-mysqlnd php-pdo php-mbstring php-xml \
    php-curl php-gd php-bcmath php-zip \
    php-opcache php-pecl-apcu

RUN sed -i 's/^#bind-address=0\.0\.0\.0/bind-address=0.0.0.0/' /etc/my.cnf.d/mariadb-server.cnf \
    && sed -i '/pid-file=\/run\/mariadb\/mariadb.pid/a\ssl=0' /etc/my.cnf.d/mariadb-server.cnf \
    && sed -i '/pid-file=\/run\/mariadb\/mariadb.pid/a\secure_file_priv=""' /etc/my.cnf.d/mariadb-server.cnf \ 
    && mysql_install_db --user=mysql --datadir=/var/lib/mysql \
    && (mysqld_safe &) \
    && sleep 5 \
    && mysql -uroot -e "\
    ALTER USER 'root'@'localhost' IDENTIFIED BY 'root'; \
    GRANT ALL PRIVILEGES ON *.* TO 'root'@'%' IDENTIFIED BY 'root' WITH GRANT OPTION; \
    DELETE FROM mysql.user WHERE user=''; \
    FLUSH PRIVILEGES;" \
    && mysqladmin -uroot -proot shutdown \
    && chmod -R 777 /usr/lib64/mariadb/plugin \
    && echo "ServerName localhost" >> /etc/httpd/conf/httpd.conf

RUN echo 'root:p@ss1234' | chpasswd \
    && useradd -m -s /bin/bash centos  \
    && echo "centos:centos" | chpasswd \
    && usermod -aG wheel centos \
    && sed -i 's/#PermitRootLogin prohibit-password/PermitRootLogin yes/' /etc/ssh/sshd_config \
    && sed -i 's/#PasswordAuthentication yes/PasswordAuthentication yes/' /etc/ssh/sshd_config \
    && sed -i 's/UsePAM yes/UsePAM no/' /etc/ssh/sshd_config \
    && ssh-keygen -A \
    && mkdir /var/run/sshd \
    && rm -f /var/run/nologin
# RUN echo "centos ALL=(ALL) NOPASSWD:ALL" >> /etc/sudoers.d/centos && \
#     chmod 0440 /etc/sudoers.d/centos

COPY supervisord.conf /etc/supervisor/

EXPOSE 22 80 3306

CMD ["/usr/bin/supervisord", "-n", "-c", "/etc/supervisor/supervisord.conf"]
