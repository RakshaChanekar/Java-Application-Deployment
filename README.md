# 🚀 Secure Java Application Deployment with Reverse Proxy on AWS

## 📌 Project Overview

This project demonstrates the migration of a **legacy Java-based Student Registration Web Application** to a **secure AWS cloud infrastructure**.

The main objective was to eliminate security risks caused by direct backend exposure by implementing a **Reverse Proxy Architecture**.

Using **Nginx as a reverse proxy** and **Apache Tomcat as the backend application server**, the system ensures that:

* Backend services are not publicly exposed
* Database access is restricted
* All traffic flows through a controlled entry point

---

## 🏗 Architecture

<img width="1536" height="1024" alt="image" src="https://github.com/user-attachments/assets/4e919f8e-647d-47c8-be73-cb12290e2eee" />


### 🔁 Traffic Flow

```
User → Nginx (Proxy Server) → Tomcat (Backend Server) → RDS (MySQL)
```

### 📊 Explanation

1. User accesses application via **Proxy Public IP (Port 80)**
2. Nginx forwards requests to **Backend Server (Port 8080)**
3. Tomcat processes the request
4. Data is stored/retrieved from **Amazon RDS (MySQL)**
5. Backend and Database are **not publicly accessible**

---

## 🛠 Technology Stack

| Layer              | Technology                           |
| ------------------ | ------------------------------------ |
| Cloud              | AWS (EC2, RDS, VPC, Security Groups) |
| Reverse Proxy      | Nginx                                |
| Application Server | Apache Tomcat 9                      |
| Backend Language   | Java (OpenJDK 11)                    |
| Database           | Amazon RDS (MySQL 8.0)               |
| JDBC Driver        | MySQL Connector/J                    |

---

## 🚀 Deployment Steps

### 1️⃣ Infrastructure Setup

* Created **2 EC2 Instances**:

  * Proxy Server (Public)
  * Backend Server (Private-like access)
* Created **RDS MySQL Database**
* Configured **Security Groups**:

  * Proxy → Public access (Port 80)
  * Backend → Only accessible from Proxy (Port 8080)
  * RDS → Only accessible from Backend (Port 3306)

---

### 2️⃣ Database Setup

```sql
CREATE DATABASE studentdb;

USE studentdb;

CREATE TABLE students (
    id INT AUTO_INCREMENT PRIMARY KEY,
    name VARCHAR(100),
    email VARCHAR(100),
    course VARCHAR(100)
);
```

---

### 3️⃣ Backend Deployment (Tomcat)

* Installed Java (OpenJDK 11)
* Installed Apache Tomcat 9
* Deployed `student.war` in `/webapps`
* Added MySQL Connector JAR to `/lib`
* Configured database connection:

```properties
db.url=jdbc:mysql://<RDS-ENDPOINT>:3306/studentdb
db.user=admin
db.password=********
```

---

### 4️⃣ Reverse Proxy Configuration (Nginx)

```nginx
location /student {
    proxy_pass http://<BACKEND_PRIVATE_IP>:8080/student;
    proxy_set_header Host $host;
    proxy_set_header X-Real-IP $remote_addr;
    proxy_set_header X-Forwarded-For $proxy_add_x_forwarded_for;
}
```

---

## 🔒 Security Implementation

✔ Backend EC2 is **not publicly accessible**
✔ Only Proxy can access Backend
✔ RDS accepts traffic only from Backend
✔ Direct access to backend results in **timeout**

---

## 🌐 Application Access

```
http://<Proxy-Public-IP>/student
```

---

## 📸 Screenshots

* ✅ Running EC2 Instances
  <img width="1919" height="888" alt="image" src="https://github.com/user-attachments/assets/f5525123-cfd7-4a3b-9334-6eb836c77f49" />
  
* ✅ Application UI via Proxy
  
  <img width="673" height="463" alt="image" src="https://github.com/user-attachments/assets/43a6609d-fcf3-4bb1-aefe-578d5087076f" />
  <img width="940" height="334" alt="image" src="https://github.com/user-attachments/assets/0e70145b-d085-4bb2-b011-483fcadf5dad" />
  
* ✅ Database Records in RDS
  
  <img width="940" height="1013" alt="image" src="https://github.com/user-attachments/assets/8612d3de-3719-47ea-b7b6-57309a28538d" />
  
## 🔒 Security Group Configuration

### Proxy Security Group
<img width="1913" height="895" alt="image" src="https://github.com/user-attachments/assets/f9f98d2b-e5a2-41c2-a458-5ffe1129683b" />

### Backend Security Group
<img width="1911" height="890" alt="image" src="https://github.com/user-attachments/assets/de59e5b5-c7c4-47b4-a09e-b61d476617a7" />

### RDS Security Group
<img width="1916" height="849" alt="image" src="https://github.com/user-attachments/assets/c0e18395-0703-4a10-a134-bae6fc9b7006" />

---

## ⚠️ Challenges & Solutions

### ❌ Nginx Error: unknown variable

✔ Fixed typo (`proxy_ass` → `proxy_add_x_forwarded_for`)

---

### ❌ apt update failed (Network unreachable)

✔ Fixed VPC Route Table and Internet Gateway

---

### ❌ 404 Not Found

✔ Ensured WAR file extracted correctly and URL path matched

---

## 📊 Key Learnings

* Reverse Proxy improves **security & scalability**
* Separation of layers (Proxy, Backend, DB)
* Importance of **Security Groups in AWS**
* Real-world deployment architecture

---

## 📦 Project Structure

```
project-root/
│
├── screenshots/
├── logs/
│   └── catalina.out
├── student.war
└── README.md
```

---

## 💡 Future Improvements

* Add HTTPS using AWS Load Balancer + SSL
* Automate deployment using Terraform
* Add CI/CD pipeline (GitHub Actions)
* Containerize using Docker

---

## 👨‍💻 Author

**Raksha Chanekar**
Cloud Engineer
AWS | DevOps | Kubernetes

---


