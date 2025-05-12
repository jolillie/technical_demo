FROM ubuntu:20.04

ENV DEBIAN_FRONTEND=noninteractive

# Install everything with apt
RUN apt-get update && apt-get install -y --no-install-recommends \
    software-properties-common \
    python3 \
    python3-apt \
    python3-pip \
    python3-setuptools \
    sshpass \
    git \
    openssh-client \
    && apt-get clean \
    && rm -rf /var/lib/apt/lists/*

RUN pip install pymongo
RUN pip install ansible==2.9.27

WORKDIR /ansible

COPY requirements.yml /ansible/requirements.yml
COPY ansible.cfg /ansible/ansible.cfg
COPY inventory.yml /ansible/inventory.yml
COPY setup_db_vm.yml /ansible/setup_db_vm.yml
COPY add_backup_job.yml /ansible/add_backup_job.yml
COPY scripts/ /ansible/scripts/
RUN ansible-galaxy collection install -r requirements.yml --force

CMD ["bash"]