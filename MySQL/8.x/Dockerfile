FROM docker.1ms.run/ubuntu:22.04

ENV DEBIAN_FRONTEND=noninteractive \
    TZ=Asia/Shanghai \
    LC_ALL=C.UTF-8

RUN apt-get update && apt-get install -y \
    wget vim iproute2 iputils-ping \
    mysql-server supervisor \
    && apt clean && \
    rm -rf /var/lib/apt/lists/*

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
    && mysqladmin -uroot -proot shutdown \
    && chmod -R 777 /usr/lib/mysql/plugin

COPY supervisord.conf /etc/supervisor/conf.d/supervisord.conf

EXPOSE 3306

CMD ["/usr/bin/supervisord", "-n"]