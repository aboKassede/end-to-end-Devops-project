pipeline {
    agent any
    tools {
        jdk "JDK17"
        maven "MAVEN3.9"
    }
    environment {
        registry = "abokassede/kubernetes"
        registryCredential = "dockerhub-creds"
        DEPLOY_BRANCH = "manifests"
    }
    stages {
        stage('Build Image') {
            steps {
                script {
                    dockerImage = docker.build("${registry}:tomcat-v${BUILD_NUMBER}")
                }
            }
        }
        stage('Push Image') {
            steps {
                script {
                    docker.withRegistry('', registryCredential) {
                        dockerImage.push("tomcat-v${BUILD_NUMBER}")
                        dockerImage.push('latest')
                    }
                }
            }
        }
        stage('Clean Local Image') {
            steps {
                sh "docker rmi ${registry}:tomcat-v${BUILD_NUMBER} || true"
            }
        }
        stage('Update Helm Values for ArgoCD') {
            steps {
                script {
                    sshagent(['gitlogin']) {    
                        sh """
                        # Fetch the latest deploy branch
                        git fetch origin ${DEPLOY_BRANCH}:${DEPLOY_BRANCH} || git checkout ${DEPLOY_BRANCH}
                        git checkout ${DEPLOY_BRANCH}
                        # Update Tomcat image tag in values.yaml
                        sed -i 's|tag: tomcat-v.*|tag: tomcat-v${BUILD_NUMBER}|' helm-chart/values.yaml
                        # Commit and push with [skip ci] to avoid retrigger
                        git config user.email "jenkins@company.com"
                        git config user.name "Jenkins"
                        git add helm-chart/values.yaml
                        git commit -m "Update Tomcat image tag to ${BUILD_NUMBER} [skip ci]"
                        git push origin ${DEPLOY_BRANCH}
                        """
                    }
                }
            }
        }

    }
}
