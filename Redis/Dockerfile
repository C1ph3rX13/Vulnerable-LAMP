FROM vulhub/redis:5.0.7

ENV DEBIAN_FRONTEND=noninteractive

RUN apt update \
    && apt install -y cron openssh-server supervisor \
    && echo 'root:p@ss1234' | chpasswd \
    && sed -i 's/#PermitRootLogin prohibit-password/PermitRootLogin yes/' /etc/ssh/sshd_config \
    && sed -i 's/UsePAM yes/UsePAM no/' /etc/ssh/sshd_config \
    && sed -i 's/#PasswordAuthentication yes/PasswordAuthentication yes/' /etc/ssh/sshd_config \
    && ssh-keygen -A \
    && ssh-keygen -t rsa -b 4096 -f /root/.ssh/id_rsa -N "p@ss1234" \
    && mkdir -p /var/run/sshd

COPY supervisord.conf /etc/supervisor/conf.d/supervisord.conf

EXPOSE 22 6379

CMD ["/usr/bin/supervisord", "-n"]
