# JavaApp-CICD — Real-Time CI/CD Pipeline for Java Application

A Spring Boot Java web application deployed through a full CI/CD pipeline:

**GitHub → Jenkins → Maven Build/Test → SonarQube → OWASP Dependency-Check → Docker Build → Trivy Scan → DockerHub → Deploy to Tomcat/Apache**

Infrastructure (the Jenkins/SonarQube/Tomcat server) is provisioned with Terraform on AWS EC2.

## Repository layout

```
JavaApp-CICD/
├── src/                     # Spring Boot application source
├── pom.xml                  # Maven build file (SonarQube + OWASP plugins wired in)
├── Dockerfile                # Multi-stage build: Maven -> Tomcat runtime
├── Jenkinsfile               # Full declarative pipeline
├── terraform/                 # Infra-as-Code for the Jenkins/SonarQube/Tomcat EC2 server
│   ├── backend.tf
│   ├── variables.tf
│   ├── variables.tfvars.example
│   ├── main.tf
│   ├── outputs.tf
│   └── user_data.sh
└── docs/
    └── JavaApp-CICD-Step-By-Step-Guide.docx
```

See `docs/JavaApp-CICD-Step-By-Step-Guide.docx` for the full build walkthrough.

## Quick local test (optional, before wiring up Jenkins)

```bash
mvn clean package
java -jar target/javaapp.war
# visit http://localhost:8080

# or with Docker
docker build -t javaapp-cicd:local .
docker run -p 8080:8080 javaapp-cicd:local
```
