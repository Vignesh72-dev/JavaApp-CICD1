#!/bin/bash
set -e
exec > /var/log/user-data.log 2>&1

echo "==== updating system ===="
dnf update -y

echo "==== installing base packages (curl-minimal already ships with AL2023, skip curl to avoid conflict) ===="
dnf install -y java-21-amazon-corretto-devel wget unzip git

java -version

echo "==== installing jenkins ===="
wget -O /etc/yum.repos.d/jenkins.repo https://pkg.jenkins.io/redhat-stable/jenkins.repo
rpm --import https://pkg.jenkins.io/redhat-stable/jenkins.io-2023.key
dnf install -y jenkins
systemctl enable jenkins
systemctl start jenkins

echo "==== installing Docker ===="
dnf install -y docker
systemctl enable docker
systemctl start docker
usermod -aG docker ec2-user
usermod -aG docker jenkins
# restart jenkins so it picks up the new docker group membership
systemctl restart jenkins

echo "==== installing Trivy ===="
cat << EOF | tee -a /etc/yum.repos.d/trivy.repo
[trivy]
name=Trivy repository
baseurl=https://aquasecurity.github.io/trivy-repo/rpm/releases/\$basearch/
gpgcheck=1
enabled=1
gpgkey=https://aquasecurity.github.io/trivy-repo/rpm/public.key
EOF
dnf -y install trivy

echo "==== installing maven ===="
dnf install -y maven

echo "==== tuning kernel for SonarQube (Elasticsearch bootstrap checks) ===="
sysctl -w vm.max_map_count=262144
echo "vm.max_map_count=262144" >> /etc/sysctl.conf

echo "==== running SonarQube on Docker port 9000 ===="
docker run -d --name sonarqube -p 9000:9000 --restart unless-stopped sonarqube:community

echo "==== done ===="
echo "Jenkins:   http://<public-ip>:8080  (initial password: /var/lib/jenkins/secrets/initialAdminPassword)"
echo "SonarQube: http://<public-ip>:9000  (default login: admin/admin)"