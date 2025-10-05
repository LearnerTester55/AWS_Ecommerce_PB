pipeline {
    agent any

    environment {
        DOCKER_IMAGE = "informatiker99/ecommerce-site:latest"
    }

    stages {
        stage('Clone Repo') {
            steps {
                git branch: 'main', url: 'https://github.com/LearnerTester55/AWS_Ecommerce_PB.git'

            }
        }

        stage('Build Docker Image') {
            steps {
                script {
                    dockerImage = docker.build(DOCKER_IMAGE, "./ecommerce")
                }
            }
        }

        stage('Push to DockerHub') {
            steps {
                script {
                    docker.withRegistry('https://index.docker.io/v1/', 'dockerhub-credentials') {
                        dockerImage.push()
                    }
                }
            }
        }

        stage('Deploy on EC2') {
            steps {
                sh '''
                docker stop ecommerce || true
                docker rm ecommerce || true
                docker pull informatiker99/ecommerce-site:latest
                docker run -d -p 80:80 --name ecommerce informatiker99/ecommerce-site:latest
                '''
            }
        }
    }
}
