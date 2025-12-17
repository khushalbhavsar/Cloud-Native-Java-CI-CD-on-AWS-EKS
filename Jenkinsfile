pipeline {
    agent any

    tools {
        maven "Maven-3.9.9"
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
                echo "📤 Pushing Docker image to Docker Hub..."
                sh 'docker push khushalbhavsar/cloud-native-maven-app:latest'
                echo "✅ Docker image pushed successfully."
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
