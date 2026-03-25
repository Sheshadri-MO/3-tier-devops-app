# 3-Tier DevOps Application

## Overview

This project demonstrates a **3-tier architecture** with full DevOps practices using **Ansible, Nginx, Node.js, MySQL, and Redis**.

The application supports **Signup & Login**, shows which server handled the request, and uses **Redis caching** for performance optimization.

---

## Architecture

```
                 USER (Browser)
                        │
                        ▼
        ┌────────────────────────────┐
        │   NGINX LOAD BALANCER      │
        │     (192.168.1.208)        │
        └────────────┬───────────────┘
                     │
         ┌───────────┴───────────┐
         ▼                       ▼
┌──────────────────┐   ┌──────────────────┐
│   APP SERVER 1   │   │   APP SERVER 2   │
│  (192.168.1.207) │   │  (192.168.1.206) │
│     Node-1       │   │     Node-2       │
└─────────┬────────┘   └─────────┬────────┘
          │                      │
          └──────────┬───────────┘
                     ▼
         ┌──────────────────────────┐
         │     REDIS CACHE          │
         │   (192.168.1.209)        │
         └──────────┬───────────────┘
                     ▼
         ┌──────────────────────────┐
         │     MYSQL DATABASE       │
         │   (192.168.1.209)        │
         └──────────────────────────┘

            MONITORING SERVER
         (192.168.1.205)
         - Prometheus
         - Grafana
```

---

##  Tech Stack

* **Backend:** Node.js (Express)
* **Database:** MySQL
* **Cache:** Redis
* **Load Balancer:** Nginx
* **Automation:** Ansible
* **Monitoring:** Prometheus + Grafana
* **Infrastructure:** Terraform 

---

## Features

* Signup & Login (same UI)
* Load balancing across multiple servers
* Displays server handling request (Node-1 / Node-2)
* Redis caching (improves performance)
* MySQL persistent storage
* Infrastructure automation using Ansible
* Monitoring with Prometheus & Grafana

---

##  Project Structure

```
devops-tf-project/
│
├── ansible/
│   ├── inventory.ini
│   ├── site.yml
│   ├── app.yml
│   ├── cache.yml
│   ├── loadbalancer.yml
│   ├── monitoring.yml
│
├── backend/
│   ├── app.js
│   ├── package.json
│
├── frontend/
│   └── index.html
│
├── terraform/
│   ├── main.tf
│   ├── variables.tf
│   ├── outputs.tf
|   ├── provider.tf
│
├── monitoring/
│   └── prometheus.yml
```

---

##  Setup Instructions

### Configure Terraform

```
terraform init
terraform plan
terraform apply
```

---

### Configure Inventory (Ansible)

Update `ansible/inventory.ini` with your VM IPs.

---

###  Run Ansible Playbook

```
cd ansible
ansible-playbook -i inventory.ini site.yml --ask-pass
```

---

###  Install Dependencies (if needed)

```
cd backend
npm install
```

---

###  Start Application

```
nohup node app.js > app.log 2>&1 &
```

---

##  Access Application

Open in browser:

```
http://192.168.1.208
```

---

## API Endpoints

### Signup

```
POST /signup
```

### Login

```
POST /login
```

### Cache Test

```
GET /cache
```

---

##  Redis Caching

* First request → MySQL (slow)
* Next request → Redis (fast)

Example:

```
 MySQL (Node-1)
 Redis (Node-2)
```

---

## Load Balancing

Nginx distributes traffic between:

* Node-1
* Node-2

Example:

```
 Response from Node-1
 Response from Node-2
```

---

## Monitoring

* **Prometheus:** http://<MONITORING IP>:9090
* **Grafana:** http://<MONITORING IP>:3000

---

## Common Issues

### MySQL connection refused

* Update bind-address to `0.0.0.0`
* Restart MySQL

### Redis connection refused

* Update bind to `0.0.0.0`
* Disable protected mode (for lab)

---
