pipeline {
    agent any

    environment {
        DOCKER_IMAGE = "informatiker99/ecommerce-site:latest"
        DOCKER_CONTEXT = "default"  // Use Docker Desktop Windows context
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
                    // Build Docker image using the correct context
                    def dockerImage = bat(script: "docker build --context %DOCKER_CONTEXT% -t %DOCKER_IMAGE% ./ecommerce", returnStdout: true).trim()
                }
            }
        }

        stage('Push to DockerHub') {
            steps {
                script {
                    // Login and push image
                    bat "docker login -u informatiker99 -p MyNewDock1600@"
                    bat "docker push %DOCKER_IMAGE%"
                }
            }
        }

        stage('Deploy on EC2') {
            steps {
                sshagent(['ec2-ssh-key']) {
                    bat """
                    ssh -o StrictHostKeyChecking=no ec2-user@35.153.19.62 ^
                        "docker stop ecommerce || true && ^
                        docker rm ecommerce || true && ^
                        docker pull informatiker99/ecommerce-site:latest && ^
                        docker run -d -p 8080:80 --name ecommerce informatiker99/ecommerce-site:latest"
                    """
                }
            }
        }
    }
}
