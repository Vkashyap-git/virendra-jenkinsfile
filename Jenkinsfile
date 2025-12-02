pipeline {
    agent any
    stages {

        stage('Git Checkout') {
            steps {
                git branch: 'main',
            url: 'https://github.com/Vkashyap-git/virendra-jenkinsfile'
            }
        }

        stage('Copy Deployment Script to Workspace') {
            steps {
                sh '''
                https://github.com/Calance-US/calance-services-jenkinsfiles.git
                    echo "Copying deployment script..."
                    cp scripts/EC2-Deployment-Dashboard .
                    chmod +x EC2-Deployment-Dashboard
                '''
            }
        }

        stage('Connect to EC2 via SSH') {
            steps {
                sshagent(credentials: [env.SSH_KEY]) {
                    sh """
                        echo "Checking EC2 connectivity..."
                        ssh -o StrictHostKeyChecking=no ${EC2_USER}@${EC2_HOST} 'hostname'
                    """
                }
            }
        }

        stage('Deploy Application') {
            steps {
                sshagent(credentials: [env.SSH_KEY]) {
                    sh """
                        echo "Transferring script to EC2..."
                        scp -o StrictHostKeyChecking=no deploy.sh ${EC2_USER}@${EC2_HOST}:/tmp/deploy.sh

                        echo "Running deployment script on EC2..."
                        ssh -o StrictHostKeyChecking=no ${EC2_USER}@${EC2_HOST} '
                            sudo chmod +x /tmp/deploy.sh &&
                            sudo /tmp/deploy.sh
                        '
                    """
                }
            }
        }

        stage('Validate Deployment') {
            steps {
                sshagent(credentials: [env.SSH_KEY]) {
                    sh """
                        echo "Validating deployment..."
                        ssh -o StrictHostKeyChecking=no ${EC2_USER}@${EC2_HOST} '
                            curl -sf http://localhost:8080 || echo "App validation failed"
                        '
                    """
                }
            }
        }

        stage('Success') {
            steps {
                echo "Deployment completed successfully! 🎉"
            }
        }
    }
}
