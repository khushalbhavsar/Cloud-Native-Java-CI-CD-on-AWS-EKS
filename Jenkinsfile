pipeline {
    agent any

    tools {
        maven "Maven-3.9.9"
    }

    stages {

        stage('Clone Repository') {
            steps {
                git branch: 'main',
                    url: 'https://github.com/khushalbhavsar/Maven-Web-App-CICD-Pipeline-on-AWS-EKS.git'
            }
        }

        stage('Maven Build') {
            steps {
                sh 'mvn clean package'
            }
        }

        stage('Docker Build') {
            steps {
                sh 'docker build -t khushalbhavsar/cloud-native-maven-app:latest .'
            }
        }

        stage('Docker Push') {
            steps {
                sh 'docker push khushalbhavsar/cloud-native-maven-app:latest'
            }
        }

        stage('Deploy to EKS') {
            steps {
                sh '''
                kubectl apply -f k8s/deployment.yaml
                kubectl apply -f k8s/service.yaml
                '''
            }
        }
    }
}
