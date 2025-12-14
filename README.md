# ☕ Web Application Migration to Docker & AWS ECR

Complete migration of a Node.js and MySQL web application from EC2 instances to Docker containers, with automated infrastructure provisioning using AWS CloudFormation and image deployment to Amazon ECR. Academic project completed as part of the **Virtualization & Cloud Computing (VECC)** module.

## 🎯 Project Objective

Migrate a coffee supplier inventory management web application, initially deployed on EC2 instances, to a containerized architecture using Docker, then publish the images to Amazon Elastic Container Registry (ECR) for scalable deployment.

## 🏗️ Architecture

### Initial Architecture (Before Migration)
```
┌─────────────────┐
│  AppServerNode  │
│   (EC2 Ubuntu)  │
│   Node.js App   │
│   Port 80       │
└────────┬────────┘
         │
         │ MySQL Connection
         ▼
┌─────────────────┐
│ MysqlServerNode │
│   (EC2 Ubuntu)  │
│   MySQL Server  │
│   Port 3306     │
└─────────────────┘
```

### Final Architecture (After Migration)
```
┌─────────────────────────────────────────────┐
│           DockerServer (EC2)                │
│                                             │
│  ┌─────────────────────────────────────┐   │
│  │   Container: node_app_1             │   │
│  │   Image: node_app:0.1               │   │
│  │   Port: 3000 → 3000                 │   │
│  │   Env: APP_DB_HOST=<mysql_ip>       │   │
│  └──────────────┬──────────────────────┘   │
│                 │                           │
│                 │ TCP/3306                  │
│                 ▼                           │
│  ┌─────────────────────────────────────┐   │
│  │   Container: mysql_1                │   │
│  │   Image: mysql:8.0.23 (custom)      │   │
│  │   Port: 3306 → 3306                 │   │
│  │   Data: my_sql.sql (imported)       │   │
│  └─────────────────────────────────────┘   │
└─────────────────────────────────────────────┘
                    │
                    │ Docker Push
                    ▼
         ┌──────────────────────┐
         │    Amazon ECR        │
         │  ┌────────────────┐  │
         │  │ node-app:0.1   │  │
         │  │ mysql-app:0.1  │  │
         │  └────────────────┘  │
         └──────────────────────┘
```

## 🛠️ Technology Stack

| Technology | Purpose |
|------------|---------|
| **Docker** | Application containerization |
| **Node.js 11** | Backend web application |
| **MySQL 8.0.23** | Relational database |
| **Amazon EC2** | Cloud compute instances |
| **Amazon ECR** | Docker image registry |
| **AWS CLI** | AWS resource management |
| **CloudFormation** | Infrastructure as Code (IaC) |

## 📦 Project Structure

```
aws-docker-ecr-migration/
├── README.md
├── .gitignore
├── cloudformation/
│   └── TP8_template.yaml
├── mysql/
│   ├── Dockerfile
│   └── my_sql.sql
└── node_app/
    ├── Dockerfile
    ├── code/
    │   └── python_3/
    └── resources/
```

## 🚀 Migration Process

### 1. Environment Setup
- Infrastructure deployment via CloudFormation template
- DockerServer EC2 instance creation
- Docker and AWS CLI installation

### 2. Node.js Application Migration
```bash
# Build Docker image
docker build -t node_app:0.1 ./node_app

# Run container with environment variables
docker run -d --name node_app_1 \
  -p 3000:3000 \
  -e APP_DB_HOST="<mysql-container-ip>" \
  -e APP_DB_USER="nodeapp" \
  -e APP_DB_PASSWORD="coffee" \
  -e APP_DB_NAME="COFFEE" \
  node_app:0.1
```

### 3. MySQL Database Migration
```bash
# Export existing database
mysqldump -P 3306 -h <mysql-host> -u nodeapp -p \
  --databases COFFEE > my_sql.sql

# Build custom MySQL image
docker build -t mysql_app:0.1 ./mysql

# Run MySQL container
docker run -d --name mysql_1 \
  -p 3306:3306 \
  -e MYSQL_ROOT_PASSWORD=rootpw \
  mysql_app:0.1

# Import data
docker exec -i mysql_1 mysql -u root -prootpw < my_sql.sql

# Create application user
docker exec -i mysql_1 mysql -u root -prootpw -e \
  "CREATE USER 'nodeapp' IDENTIFIED WITH mysql_native_password BY 'coffee'; \
   GRANT all privileges on *.* to 'nodeapp'@'%';"
```

### 4. Amazon ECR Deployment
```bash
# Authenticate Docker with ECR
aws ecr get-login-password --region us-east-1 | \
  docker login --username AWS --password-stdin \
  <account-id>.dkr.ecr.us-east-1.amazonaws.com

# Create ECR repository
aws ecr create-repository --repository-name node-app

# Tag and push image
docker tag node_app:0.1 <registry-id>.dkr.ecr.us-east-1.amazonaws.com/node-app:0.1
docker push <registry-id>.dkr.ecr.us-east-1.amazonaws.com/node-app:0.1

# Verify deployment
aws ecr list-images --repository-name node-app
```

## ✅ Project Outcomes

- ✔️ Successful Node.js application containerization
- ✔️ MySQL database migration to Docker container
- ✔️ Inter-container communication established
- ✔️ Images published to Amazon ECR
- ✔️ Application tested and validated at each stage
- ✔️ Infrastructure automated with CloudFormation IaC

## 🎓 Skills Demonstrated

- **Containerization**: Multi-tier web application dockerization
- **Docker Networking**: Bridge network configuration and container communication
- **Database Migration**: MySQL dump and restore procedures
- **AWS Services**: EC2, ECR, IAM, CloudFormation integration
- **Infrastructure as Code**: CloudFormation template design
- **DevOps Practices**: Automated deployment pipelines
- **Cloud Architecture**: Scalable and portable application design

## 🔧 Key Docker Commands Used

```bash
# Container management
docker build -t <image>:<tag> <path>
docker run -d --name <container> -p <host>:<container> <image>
docker ps
docker inspect <container>
docker exec -i <container> <command>

# Networking
docker inspect network bridge

# ECR operations
aws ecr create-repository --repository-name <name>
docker tag <source> <target>
docker push <registry>/<image>:<tag>
aws ecr list-images --repository-name <name>
```

## 📋 Prerequisites

- AWS account with EC2, ECR, and CloudFormation access
- AWS CLI configured with appropriate credentials
- Docker installed on host machine
- SSH key pair (vockey) configured
- IAM role with necessary permissions (LabRole)

## 📸 Project Validation

This project was successfully completed and validated as part of the TP11 - VECC practical work.

**Validation checklist:**
- ✅ Node.js application containerized and functional
- ✅ MySQL database migrated to container
- ✅ Inter-container communication established
- ✅ Images published to Amazon ECR
- ✅ Connectivity tests successful at each stage

## 🌟 Future Enhancements

- Implement Docker Compose for multi-container orchestration
- Add CI/CD pipeline with GitHub Actions
- Deploy to Amazon ECS or EKS for production
- Implement container health checks and monitoring
- Add persistent volumes for database data
- Configure load balancing with Application Load Balancer

## 👨‍💻 Author

**Ouail Mokhtar Khelas**  
Master's Degree - Networks and Distributed Systems (RSD)  
Constantine 2 University - Abdelhamid Mehri  
Module: VECC | Instructor: Dr. R. MENNOUR

---

*Academic project completed in 2025 - Containerized architecture migration*
