Below is a **new, cleanly formatted README file** with **your full Amazon Linux–based EKS + Jenkins setup steps integrated**, written in **professional GitHub style**.
You can **directly replace your README.md with this**.

---

# 🚀 Cloud Native Maven Web App CI/CD Pipeline on AWS EKS

This project demonstrates a **complete Cloud-Native CI/CD pipeline** for a Java web application using **Maven, Docker, Jenkins, and Kubernetes on AWS EKS**, implemented on **Amazon Linux EC2 instances** following industry best practices.

---

## 📝 Project Overview

* **Application:** Java Web App (JSP + Tomcat)
* **Build Tool:** Maven
* **CI/CD Tool:** Jenkins
* **Containerization:** Docker
* **Orchestration:** Kubernetes (AWS EKS)
* **Cloud Platform:** AWS

The pipeline automates **build → containerization → deployment** into an **AWS EKS cluster**.

---

## 🧰 Tech Stack

* Java 17
* Maven
* Jenkins
* Docker
* Kubernetes
* AWS EKS
* AWS EC2 (Amazon Linux)
* GitHub

---

## 📁 Project Structure

```
├── Dockerfile
├── Jenkinsfile
├── pom.xml
├── k8s/
│   ├── deployment.yaml
│   └── service.yaml
├── src/
│   └── main/
│       ├── java/
│       │   └── com/cloudnative/Application.java
│       └── webapp/
│           ├── index.jsp
│           └── WEB-INF/web.xml
└── README.md
```

---

## 🔄 CI/CD Pipeline Workflow

1. Jenkins clones source code from GitHub
2. Maven builds and packages the application (`.war`)
3. Docker image is created using Tomcat
4. Docker image is pushed to registry
5. Kubernetes manifests deploy the app to AWS EKS
6. Application is exposed via LoadBalancer

---

## ⚙️ Infrastructure & Setup (Amazon Linux)

### Step 1: Create EKS Management Host

* Launch **Amazon Linux 2 / Amazon Linux 2023 EC2**
* Instance type: `t2.micro`
* Install tools:

```bash
# kubectl
curl -o kubectl https://amazon-eks.s3.us-west-2.amazonaws.com/1.29.0/2024-01-04/bin/linux/amd64/kubectl
chmod +x kubectl
sudo mv kubectl /usr/local/bin/

# AWS CLI
sudo yum install unzip -y
curl "https://awscli.amazonaws.com/awscli-exe-linux-x86_64.zip" -o awscliv2.zip
unzip awscliv2.zip
sudo ./aws/install

# eksctl
curl --silent --location \
"https://github.com/weaveworks/eksctl/releases/latest/download/eksctl_$(uname -s)_amd64.tar.gz" \
| tar xz -C /tmp
sudo mv /tmp/eksctl /usr/local/bin
```

---

### Step 2: IAM Role Configuration

Create IAM role with:

* Use case: **EC2**
* Policy: `AdministratorAccess`
* Role name: `eksroleec2`

Attach this role to:

* EKS Management Host
* Jenkins Server

---

### Step 3: Create EKS Cluster

```bash
eksctl create cluster \
--name eks-cicd-cluster \
--region ap-south-1 \
--node-type t2.medium \
--zones ap-south-1a,ap-south-1b
```

Verify:

```bash
kubectl get nodes
```

---

## 🧪 Jenkins Server Setup (Amazon Linux)

### Step 4: Launch Jenkins EC2

* Instance type: `t2.medium`
* Open port `8080`

### Step 5: Install Java & Jenkins

```bash
sudo yum update -y
sudo yum install java-17-amazon-corretto -y

sudo wget -O /etc/yum.repos.d/jenkins.repo \
https://pkg.jenkins.io/redhat-stable/jenkins.repo
sudo rpm --import https://pkg.jenkins.io/redhat-stable/jenkins.io-2023.key
sudo yum install jenkins -y

sudo systemctl enable jenkins
sudo systemctl start jenkins
```

Access Jenkins:

```
http://<EC2-PUBLIC-IP>:8080
```

---

### Step 6: Configure Jenkins Tools

* **Maven:** `Manage Jenkins → Tools → Maven`
* **Docker Installation:**

```bash
sudo yum install docker -y
sudo systemctl enable docker
sudo systemctl start docker
sudo usermod -aG docker jenkins
sudo systemctl restart jenkins
```

* **Install kubectl & AWS CLI on Jenkins server**
* Configure kubeconfig:

```bash
aws eks update-kubeconfig \
--region ap-south-1 \
--name eks-cicd-cluster
```

---

## 🧾 Jenkins Pipeline (Jenkinsfile)

```groovy
pipeline {
    agent any

    tools {
        maven "Maven-3.9.9"
    }

    stages {
        stage('Clone Repo') {
            steps {
                git 'https://github.com/khushalbhavsar/Maven-Web-App-CICD-Pipeline-on-AWS-EKS.git'
            }
        }

        stage('Maven Build') {
            steps {
                sh 'mvn clean package'
            }
        }

        stage('Docker Build') {
            steps {
                sh 'docker build -t cloud-native-maven-app .'
            }
        }

        stage('Deploy to EKS') {
            steps {
                sh 'kubectl apply -f k8s/deployment.yaml'
                sh 'kubectl apply -f k8s/service.yaml'
            }
        }
    }
}
```

---

## ☸️ Kubernetes Deployment

* **Deployment:** Runs multiple replicas for high availability
* **Service:** LoadBalancer exposes application publicly

Access URL:

```
http://<AWS-LoadBalancer-DNS>/<context-path>/
```

---

## 🧹 Cleanup (Important)

After practice, delete AWS resources to avoid billing:

```bash
eksctl delete cluster --name eks-cicd-cluster --region ap-south-1
```

Terminate EC2 instances.

---

## 🔗 References

* AWS EKS: [https://docs.aws.amazon.com/eks/](https://docs.aws.amazon.com/eks/)
* Jenkins: [https://www.jenkins.io/doc/](https://www.jenkins.io/doc/)
* Docker: [https://docs.docker.com/](https://docs.docker.com/)
* Kubernetes: [https://kubernetes.io/docs/](https://kubernetes.io/docs/)

---

## 👤 Author

**Khushal Bhavsar**
GitHub: [https://github.com/khushalbhavsar](https://github.com/khushalbhavsar)

---

## 📄 License

This project is licensed under the **MIT License**.

