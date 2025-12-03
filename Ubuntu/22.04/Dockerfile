FROM ubuntu:22.04

ENV DEBIAN_FRONTEND=noninteractive \
    TZ=Asia/Shanghai \
    LC_ALL=C.UTF-8

RUN apt update && apt install -y  \
    # 基础工具
    curl wget git vim nano less openssh-server \
    # 网络工具
    iproute2 net-tools iputils-ping dnsutils telnet nmap \
    # 系统信息与调试
    procps htop lsof strace \
    # 压缩与归档
    zip unzip tar bzip2 xz-utils \
    # 脚本与运行时
    bash-completion jq tree socat supervisor \
    # 编码与文本处理
    sed grep gawk coreutils findutils \
    # 安全工具
    gnupg ca-certificates \
    # 清理缓存
    && apt clean && \
    rm -rf /var/lib/apt/lists/*

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

EXPOSE 22

CMD ["/usr/bin/supervisord", "-n"]