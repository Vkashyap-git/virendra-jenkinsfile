pipeline {
    agent any

    environment {
        EC2_USER = "ec2-user"
        EC2_HOST = "YOUR.EC2.PUBLIC.IP"
        SSH_CREDENTIALS = "ec2-ssh-key"      // Jenkins SSH credentials ID
        DEPLOY_PATH = "/opt/demo-app"
    }

    stages {

        stage('Git Checkout') {
            steps {
              git branch: 'main',
            url: 'https://github.com/Vkashyap-git/virendra-jenkinsfile'
            }
        }

        stage('Copy Deployment Script to Workspace') {
            steps {
                echo "Copying deployment script..."
                sh 'cp scripts/deploy.sh .'
            }
        }

        stage('Connect to EC2 using SSH Credentials') {
            steps {
                echo "Testing SSH connection..."
                sshagent(credentials: [env.SSH_CREDENTIALS]) {
                    sh "ssh -o StrictHostKeyChecking=no ${EC2_USER}@${EC2_HOST} 'echo Connected to EC2'"
                }
            }
        }

        stage('Deploy App to EC2') {
    steps {
        echo "Deploying application to EC2..."

        sshagent(credentials: [env.SSH_CREDENTIALS]) {

            // Copy project files to EC2
            sh """
            scp -o StrictHostKeyChecking=no -r * ${EC2_USER}@${EC2_HOST}:${DEPLOY_PATH}/
            """

            // Run the deployment script
            sh """
            ssh -o StrictHostKeyChecking=no ${EC2_USER}@${EC2_HOST} '
                cd ${DEPLOY_PATH} &&
                chmod +x deploy.sh &&
                ./deploy.sh
            '
                }
            }
        }

        stage('Validate Deployment') {
            steps {
                echo "Validating deployment..."
                sshagent(credentials: [env.SSH_CREDENTIALS]) {
                    sh """
                    ssh -o StrictHostKeyChecking=no ${EC2_USER}@${EC2_HOST} \
                    'curl -I localhost'
                    """
                }
            }
        }

        stage('Success Message') {
            steps {
                echo " Deployment completed successfully!"
            }
        }
    }
}
