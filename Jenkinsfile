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
                    // Use bat command directly instead of docker.build()
                    bat "docker build -t ${DOCKER_IMAGE} ./ecommerce"
                }
            }
        }

        stage('Push to DockerHub') {
            steps {
                script {
                    // Use bat command directly for login & push
                    bat "docker login -u informatiker99 -p MyNewDock1600@"
                    bat "docker push ${DOCKER_IMAGE}"
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
                        docker pull ${DOCKER_IMAGE} && ^
                        docker run -d -p 8080:80 --name ecommerce ${DOCKER_IMAGE}"
                    """
                }
            }
        }
    }
}
