Secure Java Application Deployment with Reverse Proxy on AWS
📌 Project Overview
This project demonstrates the migration of a legacy Java-based Student Registration Web Application to a secure AWS cloud infrastructure. The primary goal was to eliminate security risks associated with direct backend exposure by implementing a Reverse Proxy architecture.
By using Nginx as a gateway and Apache Tomcat as the application server, we ensure that the backend and database remain in a private-like environment, accessible only through a controlled entry point.
🏗 Architecture
The traffic flow follows this secure path:
User requests the application via the Proxy Public IP (Port 80).
Nginx (Proxy Server) intercepts the request and forwards it to the Tomcat (Backend Server) via the AWS internal network (Port 8080).
Tomcat processes the Java application logic and communicates with Amazon RDS (MySQL) for data persistence.
Security Groups block all direct public access to the Backend and Database.
🛠 Technology Stack
Cloud Provider: AWS (EC2, RDS, VPC, Security Groups)
Web/Proxy Server: Nginx
Application Server: Apache Tomcat 9
Database: Amazon RDS (MySQL 8.0)
Runtime: Java OpenJDK 11
Database Driver: MySQL Connector/J
🚀 Deployment Steps
1. Infrastructure Setup
RDS Instance: Launched a MySQL database. Created a schema studentdb and a table students.
Proxy EC2: Ubuntu 22.04 instance with Port 80 open to the world.
Backend EC2: Ubuntu 22.04 instance with Port 8080 open only to the Proxy Security Group.
2. Database Schema
code
SQL
CREATE DATABASE studentdb;
USE studentdb;

CREATE TABLE students (
    id INT AUTO_INCREMENT PRIMARY KEY,
    name VARCHAR(100),
    email VARCHAR(100),
    course VARCHAR(100)
);
3. Backend Deployment (Tomcat)
Installed OpenJDK 11 and configured Tomcat 9 in /opt/tomcat.
Placed mysql-connector.jar in the Tomcat /lib folder.
Deployed the student.war application to /webapps.
Configured the JDBC connection string to point to the RDS endpoint.
4. Reverse Proxy Configuration (Nginx)
Configured Nginx on the Proxy Server to forward traffic:
code
Nginx
location /student {
    proxy_pass http://<BACKEND_PRIVATE_IP>:8080/student;
    proxy_set_header Host $host;
    proxy_set_header X-Real-IP $remote_addr;
    proxy_set_header X-Forwarded-For $proxy_add_x_forwarded_for;
}
🔒 Security Validation
Restricted Access: Attempting to access the Backend EC2 IP directly on port 8080 results in a Connection Timeout.
Secure Access: The application is only reachable via http://<Proxy-Public-IP>/student.
Database Isolation: The RDS instance only accepts connections from the Backend EC2 Security Group.
⚠️ Challenges & Resolutions
Issue: Nginx failed to start with "unknown variable" error.
Resolution: Identified a typo in the config file (proxy_ass instead of proxy_add) and corrected the Nginx syntax.
Issue: apt update failed on EC2 with "Network is unreachable".
Resolution: Verified the VPC Route Table and ensured the Subnet was associated with an Internet Gateway.
Issue: 404 Not Found error on the proxy URL.
Resolution: Verified that the Tomcat webapp folder name matched the URL path and ensured the .war file was properly extracted.
📊 Deliverables
Application URL: http://<Proxy-Instance-Public-IP>/student
Database Verification: (See attached screenshots in /screenshots folder)
Deployment Logs: Available in logs/catalina.out.
👨‍💻 Author
Raksha Chanekar
Cloud Engineer | Project 1: AWS Java Deployment
