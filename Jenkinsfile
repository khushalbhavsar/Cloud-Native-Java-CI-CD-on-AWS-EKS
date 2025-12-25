pipeline {
    agent any

    tools {
        maven "myMaven"
    }

    stages {

        stage('Clone Repository') {
            steps {
                echo "📥 Starting source code checkout from GitHub..."
                git branch: 'main',
                    url: 'https://github.com/khushalbhavsar/Maven-Web-App-CICD-Pipeline-on-AWS-EKS.git'
                echo "✅ Repository cloned successfully."
            }
        }

        stage('Maven Build') {
            steps {
                echo "🔨 Starting Maven build..."
                sh 'mvn clean package'
                echo "✅ Maven build completed successfully."
            }
        }

        stage('Docker Build') {
            steps {
                echo "🐳 Building Docker image..."
                sh 'docker build -t khushalbhavsar/cloud-native-maven-app:latest .'
                echo "✅ Docker image built successfully."
            }
        }

        stage('Docker Push') {
            steps {
                echo "📤 Logging in to Docker Hub and pushing image..."
                withCredentials([usernamePassword(
                    credentialsId: 'dockerhub-creds',
                    usernameVariable: 'DOCKER_USER',
                    passwordVariable: 'DOCKER_PASS'
                )]) {
                    sh '''
                    echo "$DOCKER_PASS" | docker login -u "$DOCKER_USER" --password-stdin
                    docker push khushalbhavsar/cloud-native-maven-app:latest
                    docker logout
                    '''
                }
                echo "✅ Docker image pushed successfully to Docker Hub."
            }
        }

        stage('Deploy to EKS') {
            steps {
                echo "🚀 Deploying application to AWS EKS cluster..."
                sh '''
                kubectl apply -f k8s/deployment.yaml
                kubectl apply -f k8s/service.yaml
                '''
                echo "✅ Application deployed successfully to EKS."
            }
        }
    }

    post {
        success {
            echo "🎉 PIPELINE SUCCESS: Application built, containerized, and deployed successfully."
        }
        failure {
            echo "❌ PIPELINE FAILURE: Please check the above logs for the exact error."
        }
        always {
            echo "📌 Pipeline execution finished (success or failure)."
        }
    }
}
