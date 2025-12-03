FROM docker.1ms.run/ubuntu:22.04

ENV DEBIAN_FRONTEND=noninteractive \
    TZ=Asia/Shanghai \
    LC_ALL=C.UTF-8

RUN apt update && apt install -y  \
    # 基础工具
    curl wget git vim less openssh-server \
    # 网络工具
    iproute2 net-tools iputils-ping nmap \
    # 系统信息与调试
    procps htop lsof strace \
    # 压缩与归档
    zip unzip tar bzip2 xz-utils \
    # 脚本与运行时
    jq tree socat supervisor \
    # 编码与文本处理
    sed grep gawk coreutils findutils \
    # 安全工具
    gnupg ca-certificates \
    # 安装 PHP Apache2 MySQL
    && apt install -y \
    php8.1 \
    php8.1-fpm \
    php8.1-common \
    php8.1-mysql \
    php8.1-gd \
    php8.1-mbstring \
    php8.1-curl \
    php8.1-soap \
    php8.1-xml \
    php8.1-apcu \
    php8.1-cgi \
    php8.1-dev \
    apache2 \
    mysql-server \
    libapache2-mod-php8.1 \
    # 清理缓存
    && apt clean && \
    rm -rf /var/lib/apt/lists/*

# Apache & PHP 配置
RUN a2enmod php8.1 rewrite \
    && echo "ServerName localhost" >> /etc/apache2/apache2.conf

# MySQL 配置
RUN sed -i 's/^bind-address.*/bind-address = 0.0.0.0/' /etc/mysql/mysql.conf.d/mysqld.cnf \
    && sed -i '/^\[mysqld\]$/a secure_file_priv = ""' /etc/mysql/mysql.conf.d/mysqld.cnf \
    && sed -i '/^\[mysqld\]$/a skip-name-resolve' /etc/mysql/mysql.conf.d/mysqld.cnf \
    && service mysql start \
    && sleep 5 \
    && mysql -uroot -proot -e "\
    USE mysql;\
    CREATE USER 'root'@'%' IDENTIFIED WITH mysql_native_password BY 'root' PASSWORD EXPIRE NEVER;\
    ALTER USER 'root'@'localhost' IDENTIFIED WITH mysql_native_password BY 'root';\
    GRANT ALL PRIVILEGES ON *.* TO 'root'@'%' WITH GRANT OPTION;\
    FLUSH PRIVILEGES;" \
    && mysqladmin -uroot -proot shutdown

RUN echo 'root:p@ss1234' | chpasswd \
    && useradd -m -s /bin/bash ubuntu \
    && echo 'ubuntu:ubuntu' | chpasswd \
    && usermod -aG sudo ubuntu \
    # SSH 服务配置
    && sed -i 's/#PermitRootLogin prohibit-password/PermitRootLogin yes/' /etc/ssh/sshd_config \
    && sed -i 's/#PubkeyAuthentication yes/PubkeyAuthentication yes/' /etc/ssh/sshd_config \
    && sed -i 's/UsePAM yes/UsePAM no/' /etc/ssh/sshd_config \
    && ssh-keygen -A \
    && mkdir -p  /var/run/sshd \
    # 配置密钥
    && ssh-keygen -t rsa -b 4096 -N "" -f ~/.ssh/id_rsa \
    && cat ~/.ssh/id_rsa.pub >> ~/.ssh/authorized_keys \
    && chmod 600 ~/.ssh/id_rsa \
    && chmod 644 ~/.ssh/id_rsa.pub

# 配置 Supervisor
COPY supervisord.conf /etc/supervisor/conf.d/supervisord.conf
# SSH Banner
# RUN echo 'Banner /etc/ssh/banner.txt' >> /etc/ssh/sshd_config
# COPY banner.txt /etc/ssh/banner.txt

EXPOSE 22 80 3306

CMD ["/usr/bin/supervisord", "-c", "/etc/supervisor/conf.d/supervisord.conf"]