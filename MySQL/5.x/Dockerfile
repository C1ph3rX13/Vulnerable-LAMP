FROM hub.mirrorify.net/ubuntu:22.04

ENV DEBIAN_FRONTEND=noninteractive \
    TZ=Asia/Shanghai \
    LC_ALL=C.UTF-8

RUN apt-get update \
    && apt-get install -y \
    wget vim supervisor

COPY mysql.cnf /tmp
COPY init.sql /tmp
# MySQL Download：https://downloads.mysql.com/archives/community/

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

EXPOSE 3306

CMD ["/usr/bin/supervisord", "-n"]