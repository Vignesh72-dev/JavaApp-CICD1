# -------- Stage 1: Build the WAR with Maven --------
FROM maven:3.9-eclipse-temurin-11 AS build
WORKDIR /app
COPY pom.xml .
COPY src ./src
RUN mvn -B clean package -DskipTests

# -------- Stage 2: Run the WAR on Tomcat --------
FROM tomcat:9.0-jdk11-temurin
LABEL maintainer="ProDevOpsGuy"
LABEL project="JavaApp-CICD"

# Remove default Tomcat apps to keep the image lean
RUN rm -rf /usr/local/tomcat/webapps/*

# Deploy our app as ROOT so it's available at http://<host>:8080/
COPY --from=build /app/target/javaapp.war /usr/local/tomcat/webapps/ROOT.war

EXPOSE 8080

HEALTHCHECK --interval=30s --timeout=5s --start-period=30s \
  CMD curl -f http://localhost:8080/actuator/health || exit 1

CMD ["catalina.sh", "run"]
