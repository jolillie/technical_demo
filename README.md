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

Older AMI image lookup: [Ubuntu AMI Locator](https://cloud-images.ubuntu.com/locator/ec2/)
[1Password CLI](https://developer.1password.com/docs/cli/shell-plugins/aws/)

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
Terraform CLI vs Version control for running TF applies
Terraform Blast Radiuses and being able to blow up specific parts of the environment
Fargate takes a lot longer to get pods and service up and running.
Forgot to run galaxy command in Ansible docker container.

## Mongo Server Setup

1. Update

## Todo List

- [ ] Kubernetes Application Exercise
  - [ ] Database
    - [x] Outdated Linux VM (Ubuntu 18.04)
    - [x] On top of VM, installed outdated DB Server (MongoDB 4.4)
    - [x] Configure VM to allow SSH connections from internet
    - [ ] Configure DB and/or network to only allow connections to the DB from Apps in K8s Cluster
  - [ ] Database Authentication
    - [X] Ensure DB is configured for local auth
    - [x] Ability to construct connection string
  - [ ] Highly Privileged DB VM
    - [x] Config VM in a way that it is granted overly permissive CSP permissions
  - [ ] Object Storage
    - [ ] Create a cloud object storage resource
    - [ ] Store DB Backups
    - [x] Modify permissions on object store to allow public read access to the backups
    - [x] Modify permissions on object store to allow public listing of contents
    - [ ] Validate backups are accessible via external URL
  - [ ] DB Backups
    - [ ] Create automation to regularly backup db(s) to the created bucket / object store
  - [ ] Kubernetes Cluster
    - [ ] Deploy K8s cluster
  - [ ] Containerized Web Application
    - [ ] Deploy containerized web app onto K8s cluster
    - [ ] Ensure container employs DB auth
    - [ ] Confirm container image includes a file named "wizexercise.txt" with content
  - [ ] Public Access
    - [ ] Set up the containerized web app to be reachable from the public internet
  - [ ] Container Admin Configuration
    - [ ] configure the web app container to run with cluster-admin privileges
- [X] DevOps Exercise
  - [X] VCS/SCM
    - [X] Push code to VCS/SCM
  - [X] CI Pipeline
    - [X] Setup two CI Pipelines
      - [x] Deploy to cloud via IaC
      - [x] Build and push container app to container repo
- [ ] Cloud Detection and Response Exercise
  - [ ] Technical Security Controls
    - [ ] Have technical security controls in place before your application is in prod
    - [ ] Could be any number of things
      - [ ] compliance
      - [ ] audit
      - [ ] security
    - [ ] Security controls may be
      - [ ] Preventative
      - [ ] Detective
      - [ ] Responsive
  - [ ] Control Plane Audit Logging
    - [ ] Setup control plane audit logging for AWS
    - [ ] Show a sample event of the activity produced during the tech tasks
  - [ ] Optional: Setup Cloud Native detective controls for your CSP
  - [ ] Optional: Run a simulated attack or simulated behavior to showcase the efficacy of your preventative and detective controls
- [ ] Demo and Presentation
- [ ] Extra Credit
  - [ ] Additions that demo technical skills
  - [ ] Efficient, Repeatable, approaches to build out
  - [ ] Documented Pain points
  - [ ] Clear and intuitive
