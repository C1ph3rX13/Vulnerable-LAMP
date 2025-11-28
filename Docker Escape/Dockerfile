FROM ubuntu:22.04

ENV DEBIAN_FRONTEND=noninteractive

RUN apt update && \
    apt install -y curl vim wget \
    && curl -fsSL https://get.docker.com -o install-docker.sh \
    && sh install-docker.sh --mirror Aliyun \
    && apt clean \
    && rm -rf /var/lib/apt/lists/* \
    && rm -rf install-docker.sh

WORKDIR /root

CMD ["/bin/bash"]
