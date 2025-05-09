# Technical Demo

This is a technical demo of my capabilities.

## What is included

- Technologies
  - Kubernetes
  - MongoDB
  - AWS
- IaC
  - Terraform
  - Ansible
- CI/CD
  - Github Actions

## Maintainer

Jon Lillie

## Notes

Older AMI image lookup: https://cloud-images.ubuntu.com/locator/ec2/

```bash
docker build -t ansible-apt:2.10 .
```

```bash
docker run -it --rm -v $PWD:/ansible -v ~/.ssh:/root/.ssh ansible-apt:2.10
```

## Struggles

Finding an older ubuntu AMI was a challenge
Finding the right combination of Ubuntu Version and MongoDB
Needed an older version of ansible to work with the older versions of Ubuntu

## Mongo Server Setup

1. Update