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
                    // Build Docker image from the ecommerce folder
                    dockerImage = docker.build(DOCKER_IMAGE, "./ecommerce")
                }
            }
        }

        stage('Push to DockerHub') {
            steps {
                script {
                    // Use DockerHub credentials added in Jenkins
                    docker.withRegistry('https://index.docker.io/v1/', 'dockerhub-credentials') {
                        dockerImage.push()
                    }
                }
            }
        }

        stage('Deploy on EC2') {
            steps {
                // Deploy on EC2 via SSH
                sshagent(['ec2-ssh-credentials']) {
                    sh """
                    ssh -o StrictHostKeyChecking=no ec2-user@<EC2_PUBLIC_IP> '
                        docker stop ecommerce || true
                        docker rm ecommerce || true
                        docker pull informatiker99/ecommerce-site:latest
                        docker run -d -p 8080:80 --name ecommerce informatiker99/ecommerce-site:latest
                    '
                    """
                }
            }
        }
    }
}
