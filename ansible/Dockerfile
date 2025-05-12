FROM ubuntu:20.04

ENV DEBIAN_FRONTEND=noninteractive

# Install everything with apt
RUN apt-get update && apt-get install -y --no-install-recommends \
    software-properties-common \
    python3 \
    python3-apt \
    python3-pip \
    python3-setuptools \
    ansible \
    sshpass \
    git \
    openssh-client \
    && apt-get clean \
    && rm -rf /var/lib/apt/lists/*

RUN ansible-galaxy install -r requirements.yml

RUN pip install pymongo

WORKDIR /ansible

CMD ["bash"]