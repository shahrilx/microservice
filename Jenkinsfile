pipeline {
  agent any
  environment {
        KUBECONFIG = credentials('kubeconfig')
    }
  stages {
    stage('Cleaning Workspace') {
      steps {
        cleanWs()
      }
    }
    stage('Clone Repository') {
      steps {
        git(url: 'https://github.com/shahrilx/microservice.git', branch: 'main')
      }
    }
    stage('Filesystem Check') {
      steps {
        sh 'trivy fs --skip-db-update . > /var/lib/jenkins/security_report/filesystem_report.txt'
      }
    }
    stage('Building Images and Starting Containers') {
      steps {
        sh 'docker compose up -d'
      }
    }
        stage('Image Vulnerabilities Check') {
      steps {
        sh 'trivy image --skip-db-update shahrilx/frontend > /var/lib/jenkins/security_report/web-app-frontend-vul.txt'
        sh 'trivy image --skip-db-update shahrilx/api > /var/lib/jenkins/security_report/web-app-api-vul.txt'
        sh 'trivy image --skip-db-update shahrilx/quotes > /var/lib/jenkins/security_report/web-app-quotes-vul.txt'
      }
    }
    stage('Testing The Apps') {
      steps {
        sh 'curl localhost:8000'
        sleep(5)
        sh 'curl localhost:4000/api/status'
      }
    }
    stage('Push Image') {
      environment{
        registryCredential = 'dockerhub'
      }
      steps {
        script {
            docker.withRegistry('https://index.docker.io/v1/',registryCredential){
               sh 'docker push shahrilx/frontend:latest' 
               sh 'docker push shahrilx/api:latest' 
               sh 'docker push shahrilx/quotes:latest' 
            }
        }
      }
    }
    stage('Clean Container and Image') {
      steps {
        sh 'docker compose down'
        sh 'docker rmi shahrilx/frontend:latest'
        sh 'docker rmi shahrilx/api:latest'
        sh 'docker rmi shahrilx/quotes:latest'
      }
    }
    stage('Deploy To Production') {
      steps {
        sh 'kubectl apply -f kubernetes/.'
      }
    }

  }
}
