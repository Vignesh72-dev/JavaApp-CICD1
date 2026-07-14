pipeline {
    agent any

    tools {
        jdk 'jdk11'
        maven 'maven3'
    }

    environment {
        SCANNER_HOME     = tool 'sonar-scanner'
        DOCKERHUB_USER   = 'vigneshnataraj'          // <-- change me
        IMAGE_NAME       = "${DOCKERHUB_USER}/javaapp-cicd"
        IMAGE_TAG        = "${env.BUILD_NUMBER}"
        TOMCAT_WEBAPPS   = '/opt/apache-tomcat-9.0.65/webapps'
        WORKSPACE_WAR    = "${WORKSPACE}/target/javaapp.war"
    }

    options {
        timestamps()
        buildDiscarder(logRotator(numToKeepStr: '10'))
    }

    stages {

        stage('1. Checkout Source Code') {
            steps {
                git branch: 'main',
                    url: 'https://github.com/Vignesh72-dev/JavaApp-CICD1.git',
                    credentialsId: 'github-cred'
            }
        }

        stage('2. Compile') {
            steps {
                sh 'mvn clean compile'
            }
        }

        stage('3. Unit Test') {
            steps {
                sh 'mvn test'
            }
            post {
                always {
                    junit allowEmptyResults: true, testResults: 'target/surefire-reports/*.xml'
                }
            }
        }

        stage('4. SonarQube Analysis') {
            steps {
                withSonarQubeEnv('sonar-server') {
                    sh '''
                        $SCANNER_HOME/bin/sonar-scanner \
                          -Dsonar.projectName=JavaApp-CICD \
                          -Dsonar.projectKey=JavaApp-CICD \
                          -Dsonar.java.binaries=target/classes
                    '''
                }
            }
        }

        stage('5. Quality Gate') {
            steps {
                timeout(time: 5, unit: 'MINUTES') {
                    waitForQualityGate abortPipeline: false
                }
            }
        }

        stage('6. OWASP Dependency Check') {
            steps {
                withCredentials([string(credentialsId: 'nvd-api-key', variable: 'NVD_API_KEY')]) {
                    dependencyCheck additionalArguments: "--scan ./ --format HTML --format XML --nvdApiKey ${NVD_API_KEY}",
                                    odcInstallation: 'DP-Check'
                }
                dependencyCheckPublisher pattern: '**/dependency-check-report.xml'
            }
        }

        stage('7. Build WAR Package') {
            steps {
                sh 'mvn clean package -DskipTests'
            }
        }

        stage('8. Build & Tag Docker Image') {
            steps {
                script {
                    sh "docker build -t ${IMAGE_NAME}:${IMAGE_TAG} -t ${IMAGE_NAME}:latest ."
                }
            }
        }

        stage('9. Trivy Image Scan') {
            steps {
                sh "trivy image --severity HIGH,CRITICAL --format table -o trivy-report.txt ${IMAGE_NAME}:${IMAGE_TAG} || true"
                sh 'cat trivy-report.txt'
            }
        }

        stage('10. Push Image to DockerHub') {
            steps {
                withDockerRegistry(credentialsId: 'docker-cred', url: '') {
                    sh "docker push ${IMAGE_NAME}:${IMAGE_TAG}"
                    sh "docker push ${IMAGE_NAME}:latest"
                }
            }
        }

        stage('11. Deploy Container') {
            steps {
                sh """
                    docker rm -f javaapp-container || true
                    docker run -d --name javaapp-container -p 8081:8080 ${IMAGE_NAME}:latest
                """
            }
        }

        stage('12. Deploy WAR to Tomcat / Apache Server') {
            steps {
                sh "sudo /bin/cp ${WORKSPACE_WAR} ${TOMCAT_WEBAPPS}/petclinic.war"
            }
        }
        
    }
    post {
        always {
            echo 'Pipeline finished. Cleaning up dangling docker images...'
            sh 'docker image prune -f || true'
        }
        success {
            emailext (
                subject: "SUCCESS: Build #${env.BUILD_NUMBER} - ${env.JOB_NAME}",
                body: "Good news! The pipeline for ${env.JOB_NAME} build #${env.BUILD_NUMBER} completed successfully.\n\nCheck it: ${env.BUILD_URL}",
                to: 'natarajvicky72@gmail.com'
                
            )
        }
        failure {
            emailext (
                subject: "FAILED: Build #${env.BUILD_NUMBER} - ${env.JOB_NAME}",
                body: "The pipeline for ${env.JOB_NAME} build #${env.BUILD_NUMBER} failed.\n\nCheck it: ${env.BUILD_URL}",
                to: 'natarajvicky72@gmail.com'
                
            )
        }
    }
}
