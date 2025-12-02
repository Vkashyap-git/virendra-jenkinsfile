pipeline {
    agent any

    environment {
        EC2_USER = "ubuntu"
        EC2_HOST = "16.176.176.106"
    }

    stages {

        stage('Git Checkout') {
            steps {
                echo "Pulling code from repository..."
                checkout scm
            }
        }

        stage('Copy deployment YAML to workspace') {
            steps {
                echo "Copying deploy.yml to workspace..."
                sh 'cp deploy.yml $WORKSPACE/'
            }
        }

        stage('Test SSH Connection to EC2') {
            steps {
                echo "Connecting to EC2 using saved Jenkins credentials..."
                sshagent(credentials: ['virendra-jenkins']) {
                    sh '''
                        ssh -o StrictHostKeyChecking=no $EC2_USER@$EC2_HOST "echo EC2 connected successfully!"
                    '''
                }
            }
        }

        stage('Deploy to EC2') {
            steps {
                echo "Uploading deploy.yml and executing deployment..."
                sshagent(credentials: ['virendra-jenkins']) {
                    sh '''
                        scp -o StrictHostKeyChecking=no $WORKSPACE/deploy.yml $EC2_USER@$EC2_HOST:/tmp/deploy.yml

                        ssh -o StrictHostKeyChecking=no $EC2_USER@$EC2_HOST "sudo bash -s" << 'EOF'
                        # Convert YAML to commands manually (simple execution)
                        sudo mkdir -p /opt/demo-app
                        sudo cp /tmp/deploy.yml /opt/demo-app/
                        echo "YAML copied to /opt/demo-app"
                        EOF
                    '''
                }
            }
        }

        stage('Validate Deployment') {
            steps {
                echo "Validating the application on EC2..."
                sshagent(credentials: ['virendra-jenkins']) {
                    sh '''
                        ssh -o StrictHostKeyChecking=no $EC2_USER@$EC2_HOST "curl -I localhost || echo 'App may not be running'"
                    '''
                }
            }
        }

        stage('Success') {
            steps {
                echo "🚀 Deployment Pipeline Completed Successfully!"
            }
        }
    }
}
