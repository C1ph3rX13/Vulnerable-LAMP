FROM docker-0.unsee.tech/ubuntu:22.04

ENV DEBIAN_FRONTEND=noninteractive

# MySQL 下载地址：https://downloads.mysql.com/archives/community/

COPY mysql.cnf /tmp
COPY init.sql /tmp
RUN apt update \
    && apt install -y libncurses5 libaio1 libmecab2 wget \
    && cd /opt \
    && wget https://cdn.mysql.com/archives/mysql-5.7/mysql-server_5.7.34-1ubuntu18.04_amd64.deb-bundle.tar \
    && tar -xvf mysql-server*.tar -C /opt \
    && rm mysql-server_*.deb-bundle.tar \
    && rm mysql-test*.deb && rm mysql-community-test*.deb \
    && dpkg -i *.deb || true \
    && apt install -f -y \
    && rm -rf *.deb \
    && mv /tmp/mysql.cnf /etc/mysql/mysql.cnf \
    && chmod 644 /etc/mysql/mysql.cnf \
    && (mysqld_safe &) \
    && sleep 5 \
    && mysql -uroot -proot -e "SOURCE /tmp/init.sql;" \
    && rm /tmp/init.sql

EXPOSE 3306

CMD ["mysqld_safe"]
